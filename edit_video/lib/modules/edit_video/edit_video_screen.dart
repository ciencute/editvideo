import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';

enum VideoStatus { Default, Doing, Finish }

class EditVideoScreen extends StatefulWidget {
  const EditVideoScreen({super.key});

  @override
  State<EditVideoScreen> createState() => _EditVideoScreenState();
}

class _EditVideoScreenState extends State<EditVideoScreen> {
  VideoStatus status = VideoStatus.Default;
  List<String> rawVideos = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _showStatus(),
    );
  }

  Widget _defaultView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              pickVideo();
            },
            child: Center(
              child: Lottie.asset(
                'assets/anim/anim_video.json',
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _showStatus() {
    if (status == VideoStatus.Default) {
      return _defaultView();
    }
    if (status == VideoStatus.Doing) {
      return const SizedBox(
        height: 70,
        width: 70,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return _viewVideos(rawVideos, context);
    }
  }

  void pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowCompression: true,
    );

    if (result != null) {
      String? videoPath = result.files.single.path;
      if (videoPath != null) {
        status = VideoStatus.Doing;
        await cutVideoIntoSegments(videoPath).then((value) {
          if (value.isNotEmpty) {
            setState(() {
              status = VideoStatus.Finish;
            });
          }
        });
      }
    } else {}
  }

  Future<List<String>> cutVideoIntoSegments(String videoPath) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String newPath = '${directory.path}/video_cut';

    if (!(await Directory(newPath).exists())) {
      await Directory(newPath).create(recursive: true);
      print('Đã tạo thư mục video_cut.');
    } else {
      print('Thư mục video_cut đã tồn tại.');
    }

    final mediaInformation = await FFprobeKit.getMediaInformation(videoPath);
    final durationInSeconds = await mediaInformation.getDuration();
    final segmentDurationInSeconds = 60;
    final List<String> cutVideoPaths = [];

    final numberOfSegments = (durationInSeconds / segmentDurationInSeconds).ceil();
    final remainingDuration = durationInSeconds % segmentDurationInSeconds;

    for (var i = 0; i < numberOfSegments; i++) {
      final startTimeInSeconds = i * segmentDurationInSeconds;
      var endTimeInSeconds = (i + 1) * segmentDurationInSeconds;

      if (endTimeInSeconds > durationInSeconds) {
        endTimeInSeconds = durationInSeconds;
      }

      final outputFileName = '$newPath/segment_$i.mp4';

      if (await File(outputFileName).exists()) {
        await File(outputFileName).delete();
        print('Đã xóa file cũ thành công');
      }

      final command = [
        '-i',
        videoPath,
        '-ss',
        startTimeInSeconds.toString(),
        '-t',
        (endTimeInSeconds - startTimeInSeconds).toString(),
        '-c',
        'copy',
        outputFileName,
      ];

      final session = await FFmpegKit.executeAsync(command.join(' '));
      final returnCode = await session.getReturnCode();
      if (returnCode == ReturnCode.success) {
        cutVideoPaths.add(outputFileName);
        print('Đã cắt đoạn $i thành công');
      } else {
        print('Lỗi khi cắt đoạn $i');
      }
    }

    if (remainingDuration > 0 && remainingDuration < segmentDurationInSeconds) {
      final outputFileName = '$newPath/last_segment.mp4';

      if (await File(outputFileName).exists()) {
        await File(outputFileName).delete();
        print('Đã xóa file cũ thành công');
      }

      final command = [
        '-i',
        videoPath,
        '-ss',
        (durationInSeconds - remainingDuration).toString(),
        '-t',
        remainingDuration.toString(),
        '-c',
        'copy',
        outputFileName,
      ];

      final session = await FFmpegKit.executeAsync(command.join(' '));
      final returnCode = await session.getReturnCode();
      if (returnCode == ReturnCode.success) {
        cutVideoPaths.add(outputFileName);
        print('Đã cắt video cuối cùng thành công');
      } else {
        print('Lỗi khi cắt video cuối cùng');
      }
    }

    return cutVideoPaths;
  }



  _viewVideos(List<String> videos, BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return FutureBuilder<VideoData?>(
            future: FlutterVideoInfo().getVideoInfo(videos[index]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ListTile(
                  title: Text('Loading...'),
                );
              } else if (snapshot.hasError) {
                return const ListTile(
                  title: Text('Error loading thumbnail'),
                );
              } else if (snapshot.hasData) {
                return ListTile(
                  title: Text('Video ${index + 1}'),
                  onTap: () {
                    // Xử lý khi người dùng chọn video
                    // Ví dụ: mở video bằng một player hoặc thực hiện hành động khác
                  },
                );
              } else {
                return const ListTile(
                  title: Text('No thumbnail available'),
                );
              }
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 32),
        itemCount: videos.length);
  }
}
