import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/log.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/session.dart';
import 'package:ffmpeg_kit_flutter/statistics.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_editor/video_editor.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';

import 'video_editor_screen.dart';

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
    final ImagePicker _picker = ImagePicker();
    final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);

    if (mounted && file != null) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => VideoEditor(file: File(file.path)),
        ),
      );
    }
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
