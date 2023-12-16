import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class BarcodeHelperPainter extends CustomPainter {
  BarcodeHelperPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.lightGreenAccent;

    final Paint background = Paint()..color = const Color(0x99000000);

    Paint colorPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    ParagraphBuilder builder = ParagraphBuilder(
      ParagraphStyle(
          textAlign: TextAlign.center,
          fontSize: 16
      )
    );
    builder.pushStyle(
        ui.TextStyle(color: Colors.white));
    builder.addText('hint_scan_qrcode'.tr());
    builder.pop();

    // Store the points for the bounding box
    double left = double.infinity;
    double top = double.infinity;
    double right = double.negativeInfinity;
    double bottom = double.negativeInfinity;

    double centerX = size.width / 2;
    double centerY = size.height / 2;

    left = centerX / 3 ;
    right = size.width - left;
    top = centerY - (right - left) / 2;
    bottom = centerY + (right - left) / 2;

    _drawBorderBarCode(left, top, right, bottom, colorPaint, canvas);

    canvas.drawParagraph(
      builder.build()
        ..layout(ParagraphConstraints(
          width: right - left + 32,
        )),
      Offset(left - 16, top - 48),
    );
  }

  void _drawBorderBarCode(double left, double top, double right, double bottom,
      Paint colorPaint, Canvas canvas) {
    left -= 10;
    top -= 10;
    right += 10;
    bottom += 10;
    double cornerSize = 16;
    double cornerRadius = 16;
    double padding = 16;

    Path topRightArc = Path()
      ..moveTo(right - cornerSize, top)
      ..arcToPoint(Offset(right, top + cornerSize),
          radius: Radius.circular(cornerRadius))
      ..lineTo(right, top + cornerSize + padding)
      ..moveTo(right - cornerSize, top)
      ..lineTo(right - cornerSize - padding, top);

    Path topLeftArc = Path()
      ..moveTo(left, top + cornerSize)
      ..arcToPoint(Offset(left + cornerSize, top),
          radius: Radius.circular(cornerRadius))
      ..lineTo(left + cornerSize + padding, top)
      ..moveTo(left, top + cornerSize)
      ..lineTo(left, top + cornerSize + padding);

    Path bottomLeftArc = Path()
      ..moveTo(left + cornerSize, bottom)
      ..arcToPoint(Offset(left, bottom - cornerSize),
          radius: Radius.circular(cornerRadius))
      ..lineTo(left, bottom - cornerSize - padding)
      ..moveTo(left + cornerSize, bottom)
      ..lineTo(left + cornerSize + padding, bottom);

    Path bottomRightArc = Path()
      ..moveTo(right, bottom - cornerSize)
      ..arcToPoint(Offset(right - cornerSize, bottom),
          radius: Radius.circular(cornerRadius))
      ..lineTo(right - cornerSize - padding, bottom)
      ..moveTo(right, bottom - cornerSize)
      ..lineTo(right, bottom - cornerSize - padding);

    canvas.drawPath(topRightArc, colorPaint);
    canvas.drawPath(topLeftArc, colorPaint);
    canvas.drawPath(bottomLeftArc, colorPaint);
    canvas.drawPath(bottomRightArc, colorPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
