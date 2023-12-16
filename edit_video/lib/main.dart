import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'application.dart';
import 'di/locator.dart';
List<CameraDescription> cameras = [];
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  _setupLocator();
  _setupCamera();
  runApp( const Application());
}

void _setupCamera()async{
  try {
    cameras = await availableCameras();
  } on CameraException catch (e, stacktrace) {
    // LogUtil.e("cameras: ", ex: e, stacktrace: stacktrace);
  }
}

void _setupLocator()async{
  try{
    await setupLocator();
  }catch(e){

  }
}
