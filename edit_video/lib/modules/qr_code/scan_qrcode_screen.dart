import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:any_link_preview/any_link_preview.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';


import '../../../main.dart';
import '../../const/const.dart';
import '../../di/locator.dart';
import '../../routes/router.dart';
import '../../service/navigation_service.dart';
import '../../utils/themes/theme.dart';
import '../../utils/widget/alert_util.dart';
import '../../utils/widget/gallery_access.dart';
import 'components/painters/barcode_detector_painter.dart';
import 'components/painters/barcode_helper_painter.dart';
import 'view/result_qrcode_dialog.dart';

const scanQRCodeScreen = "scan_qrcode_screen";

class ScanQRCodeScreen extends StatefulWidget {
  const ScanQRCodeScreen({Key? key}) : super(key: key);

  @override
  State<ScanQRCodeScreen> createState() => _ScanQRCodeScreenState();
}

class _ScanQRCodeScreenState extends State<ScanQRCodeScreen> {
  // final BarcodeScanner _barcodeScanner = BarcodeScanner(formats: [
  //   BarcodeFormat.pdf417,
  //   BarcodeFormat.dataMatrix,
  //   BarcodeFormat.qrCode,
  //   BarcodeFormat.aztec
  // ]);
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  bool _canProcess = true;
  bool _isLoading = false;
  bool _isBusy = false;
  bool _isProcessImage = false;
  CustomPaint? _customPaint;
  final CustomPaint _helpPaint = CustomPaint(painter: BarcodeHelperPainter());

  final CameraLensDirection initialDirection = CameraLensDirection.back;
  CameraController? _controller;
  int _cameraIndex = 0;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;

  String _barCodeValue = '';

  Timer? _timerStopDetect;

  @override
  void initState() {
    super.initState();
    if (cameras.any(
      (element) =>
          element.lensDirection == initialDirection &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere((element) =>
            element.lensDirection == initialDirection &&
            element.sensorOrientation == 90),
      );
    } else {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere(
          (element) => element.lensDirection == initialDirection,
        ),
      );
    }
    _startLiveFeed();
  }

  @override
  void dispose() {
    _timerStopDetect?.cancel();
    _canProcess = false;
    _barcodeScanner.close();
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: SafeArea(
          child: Column(
            children: [
              _liveFeedBody(),

            ],
          ),
        ));
  }

  Widget _liveFeedBody() {
    if (_controller?.value.isInitialized == false) {
      return Container();
    }

    final size = MediaQuery.of(context).size;
    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * _controller!.value.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Transform.scale(
          scale: scale,
          child: Center(
            child: CameraPreview(_controller!),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
          child: (_customPaint != null && _barCodeValue.isNotEmpty)
              ? _customPaint!
              : _helpPaint,
        ),
        Positioned(
          bottom: kDefaultPadding,
          left: kDefaultPadding * 2,
          right: kDefaultPadding * 2,
          child: _controlCameraWidget(context),
        ),
        Positioned(
            top: kDefaultPadding,
            left: kDefaultPadding,
            child: _closeActionButton(context)),
        if (_isLoading)
          const Center(
            child: SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  backgroundColor: kWhiteColor,
                  strokeWidth: 2,
                )),
          )
      ],
    );
  }

  Widget _closeActionButton(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: InkWell(
            onTap: () {
              // locator<NavigationService>().pop();
            },
            child: Container(
              height: 44.0,
              width: 44.0,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.black38),
              child: const Icon(
                Icons.close,
                size: 20,
                color: Colors.white,
              ),
            )));
  }

  Widget _controlCameraWidget(BuildContext context) {
    return SafeArea(
        top: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Padding(
            //     padding: const EdgeInsets.symmetric(
            //         horizontal: kDefaultPadding, vertical: kDefaultPadding),
            //     child: Slider(
            //       value: zoomLevel,
            //       min: minZoomLevel,
            //       max: maxZoomLevel,
            //       onChanged: (newSliderValue) {
            //         setState(() {
            //           zoomLevel = newSliderValue;
            //           _controller!.setZoomLevel(zoomLevel);
            //         });
            //       },
            //       divisions: (maxZoomLevel - 1).toInt() < 1
            //           ? null
            //           : (maxZoomLevel - 1).toInt(),
            //     )),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      _chooseImage(context);
                    },
                    child: Container(
                      height: 44.0,
                      width: 44.0,
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black38),
                      child: Icon(
                        Icons.image,
                        size: 24,
                        color: _controller?.value.flashMode == FlashMode.torch
                            ? Colors.white
                            : Colors.white54,
                      ),
                    )),
                const Spacer(),
                GestureDetector(
                    onTap: () {
                      _switchFlash();
                    },
                    child: Container(
                      height: 44.0,
                      width: 44.0,
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black38),
                      child: Icon(
                        _controller?.value.flashMode == FlashMode.torch
                            ? Icons.flashlight_on
                            : Icons.flashlight_off,
                        size: 24,
                        color: _controller?.value.flashMode == FlashMode.torch
                            ? Colors.white
                            : Colors.white54,
                      ),
                    ))
              ],
            )
          ],
        ));
  }

  Future _startLiveFeed() async {
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        zoomLevel = value;
        minZoomLevel = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
      });
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    try {
      await _controller?.stopImageStream();
    } catch (_) {}
    await _controller?.dispose();
    _controller = null;
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return GalleryPopUp(
          onAllow: () {
            openAppSettings();
          },
        );
      },
    );
  }

  Future<void> _requestPermissionPhoto() async {
    final isPermanentlyDenied = await Permission.photos.isPermanentlyDenied;
    if (isPermanentlyDenied) {
      setState(() {
        _showDialog(context);
      });
      return;
    }

    Map<Permission, PermissionStatus> statuses;
    if (Platform.isAndroid) {
      statuses = await [Permission.photos, Permission.storage].request();
    } else {
      statuses = await [Permission.photos].request();
    }
    bool isGrant = false;
    for (var element in statuses.keys) {
      PermissionStatus? status = statuses[element];
      if (status?.isGranted == true) {
        isGrant = true;
        break;
      }
    }
    if (!isGrant) {
      // AlertUtil.showToastError(msg: "permission_is_denied".tr());
    } else {
      chooseImageGallery().then((pickedFile) {
        if (pickedFile != null) {
          try {
            _processFile(pickedFile);
          } catch (_) {}
        }
      });
    }
  }

  Future<bool> _checkPermissionPhoto() async {
    PermissionStatus statuses;
    if (Platform.isAndroid) {
      final androidSdk = (deviceInfo['version.sdkInt'] as int?) ?? 0;
      if (androidSdk <= 32) {
        statuses = await Permission.storage.status;
      } else {
        statuses = await Permission.photos.status;
      }
    } else {
      statuses = await Permission.photos.status;
    }

    bool isGrant = true;
    if (statuses.isDenied == true || statuses.isPermanentlyDenied) {
      isGrant = false;
    }
    return isGrant;
  }

  Future _chooseImage(BuildContext context) async {
    _checkPermissionPhoto().then((value) {
      if (value) {
        chooseImageGallery().then((pickedFile) {
          if (pickedFile != null) {
            try {
              _processFile(pickedFile);
            } catch (_) {}
          }
        });
      } else {
        _requestPermissionPhoto();
      }
    });
  }
  static Future<XFile?> chooseImageGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 100);
    return pickedFile;
  }
  Future _processFile(XFile pickedFile) async {
    if (_isProcessImage) return;
    _isProcessImage = true;
    final inputImage = await _inputImageFromXFile(pickedFile);

    final barcodes = await _barcodeScanner.processImage(inputImage);
    Barcode? barcode;
    if (barcodes.isNotEmpty) {
      barcode = barcodes.firstWhere(
          (element) => element.rawValue == _barCodeValue,
          orElse: () => barcodes.first);
    }

    if (barcode == null) {
      _barCodeValue = "";
      AlertUtil.showToastError(msg: 'error_scan_choose_image'.tr());
    }
    _isProcessImage = false;
    if (mounted) {
      setState(() {});
    }

    if (!_canProcess) return;
    String detectBarcode = barcode?.rawValue ?? '';
    if (detectBarcode.isNotEmpty &&
        (detectBarcode != _barCodeValue || !isShowResult)) {
      _barCodeValue = detectBarcode;
      _detectBarcode();
    } else {
      _canProcess = true;
    }
  }

  Future _switchFlash() async {
    setFlashMode().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> setFlashMode() async {
    if (_controller == null) {
      return;
    }

    try {
      var mode = _controller?.value.flashMode == FlashMode.torch
          ? FlashMode.off
          : FlashMode.torch;
      await _controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      _logError(e.code, e.description);
      return;
    }
  }

  void _logError(String code, String? message) {
    if (message != null) {
      // LogUtil.d('Error: $code\nError Message: $message');
    } else {
/*      LogUtil.d('Error: $code');*/
    }
  }

  Future _processCameraImage(CameraImage image) async {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) {
      return;
    }
    try {
      _processImage(inputImage);
    } catch (_) {}
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (_isBusy) return;
    _isBusy = true;
    final barcodes = await _barcodeScanner.processImage(inputImage);
    Barcode? barcode;
    if (barcodes.isNotEmpty) {
      barcode = barcodes.firstWhere(
          (element) => element.rawValue == _barCodeValue,
          orElse: () => barcodes.first);
    }
    if (barcode != null) {
      if (inputImage.metadata?.size != null &&
          inputImage.metadata?.rotation != null) {
        final painter = BarcodeDetectorPainter(
            barcode, inputImage.metadata!.size, inputImage.metadata!.rotation);
        _customPaint = CustomPaint(painter: painter);
        _timerStopDetect?.cancel();
      } else {
        _customPaint = null;
        _barCodeValue = '';
        _timerStopDetect?.cancel();
      }
    } else {
      _resetDetectBarcode();
    }

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }

    if (!_canProcess) return;
    String detectBarcode = barcode?.rawValue ?? '';
    if (detectBarcode.isNotEmpty &&
        (detectBarcode != _barCodeValue || !isShowResult)) {
      _barCodeValue = detectBarcode;
      _detectBarcode();
    } else {
      _canProcess = true;
    }
  }

  void _resetDetectBarcode() {
    _timerStopDetect?.cancel();
    _timerStopDetect = Timer(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      _customPaint = null;
      _barCodeValue = '';
      setState(() {});
    });
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  Future<InputImage> _inputImageFromXFile(XFile pickedFile) async {
    return InputImage.fromFilePath(pickedFile.path);
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) {
      // LogUtil.d("_inputImageFromCameraImage _controller null");
      return null;
    }

    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/android/src/main/java/com/google_mlkit_commons/InputImageConverter.java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/ios/Classes/MLKVisionImage%2BFlutterPlugin.m
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart
    final camera = cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    // print(
    //     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) {
        // LogUtil.d("_inputImageFromCameraImage rotationCompensation null");
        return null;
      }
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
      // print('rotationCompensation: $rotationCompensation');
    }
    if (rotation == null) {
      // LogUtil.d("_inputImageFromCameraImage rotation null");
      return null;
    }
    // print('final rotation: $rotation');

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      // LogUtil.d("_inputImageFromCameraImage format null");
      return null;
    }

    // print('final format $format');

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) {
      // LogUtil.d("_inputImageFromCameraImage image.planes empty");
      return null;
    }
    final plane = image.planes.first;

    // print('final plane ${plane.bytesPerRow}');

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  bool _getUrlValid(String url) {
    bool isUrlValid = AnyLinkPreview.isValidLink(
      url,
      protocols: ['http', 'https'],
    );
    return isUrlValid;
  }

  bool isShowResult = false;

  void _detectBarcode() async {
    _canProcess = false;
    Metadata? metadata;
    setState(() {
      _isLoading = true;
    });
    bool isValid = _getUrlValid(_barCodeValue);
    if (isValid) {
      metadata = await AnyLinkPreview.getMetadata(
          link: _barCodeValue, cache: const Duration(days: 7));
    }
    setState(() {
      _isLoading = false;
    });
    _showResultDetectBarcode(metadata);
  }

  void _showResultDetectBarcode(Metadata? metadata) async {
    Navigator.popUntil(
        context, ModalRoute.withName(ScanQRCodeScreenRoute.name));
    isShowResult = true;
    await showModalBottomSheet(
        isDismissible: false,
        elevation: 0.0,
        context: context,
        routeSettings: const RouteSettings(name: 'result_barcode'),
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return ResultQRCodeSheet(
              barcodeValue: _barCodeValue, metaData: metadata);
        });
    _customPaint = null;
    _barCodeValue = '';
    Future.delayed(const Duration(milliseconds: 1500), () {
      isShowResult = false;
      _canProcess = true;
      _isLoading = false;
      setState(() {});
    });
  }
}
