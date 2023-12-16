
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../themes/theme.dart';
import 'app_error_sheet.dart';

class AlertUtil {
  static void showToast(
      {String msg = '',
      Toast toastLength = Toast.LENGTH_SHORT,
      ToastGravity gravity = ToastGravity.TOP,
      Color backgroundColor = kAlertColor,
      Color textColor = kWhiteColor,
      ShowToastType type = ShowToastType.something,
      double fontSize = 14.0}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  static void showToastError(
      {String msg = '',
      Toast toastLength = Toast.LENGTH_SHORT,
      ToastGravity gravity = ToastGravity.TOP,
      Color backgroundColor = const Color(0xFFFF424F),
      Color textColor = Colors.white,
      ShowToastType type = ShowToastType.something,
      double fontSize = 14.0}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  static void showToastSuccess(
      {String msg = '',
      Toast toastLength = Toast.LENGTH_SHORT,
      ToastGravity gravity = ToastGravity.TOP,
      Color backgroundColor = kAlertColor,
      Color textColor = kSuccessColor,
      ShowToastType type = ShowToastType.something,
      double fontSize = 14.0}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  static void showErrorView(BuildContext context, String screenName, String message) {
    showModalBottomSheet(
        elevation: 0.0,
        context: context,
        barrierColor: Colors.black.withOpacity(0.8),
        backgroundColor: Colors.transparent,
        useSafeArea: true,
        builder: (context) {
          return AppErrorBottomSheet(screenName: screenName ,message: message);
        });
  }
}

enum ShowToastType { copy, process, something }
