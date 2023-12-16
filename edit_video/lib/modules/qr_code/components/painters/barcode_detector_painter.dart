import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

import 'coordinates_translator.dart';

class BarcodeDetectorPainter extends CustomPainter {
  BarcodeDetectorPainter(this.barcode, this.absoluteImageSize, this.rotation);

  final Barcode barcode;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  static const int paddingBarcode = 30;

  @override
  void paint(Canvas canvas, Size size) {
    // final Paint paint = Paint()
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 2.0
    //   ..color = Colors.lightGreenAccent;
    //
    // final Paint background = Paint()..color = Color(0x99000000);

    Paint colorPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    /*
      final ParagraphBuilder builder = ParagraphBuilder(
        ParagraphStyle(
            textAlign: TextAlign.left,
            fontSize: 16,
            textDirection: TextDirection.ltr),
      );
      builder.pushStyle(
          ui.TextStyle(color: Colors.lightGreenAccent, background: background));
      builder.addText('${barcode.displayValue}');
      builder.pop();
       */

    // Store the points for the bounding box
    double left = double.infinity;
    double top = double.infinity;
    double right = double.negativeInfinity;
    double bottom = double.negativeInfinity;
    final cornerPoints = barcode.cornerPoints;
    final List<Offset> offsetPoints = <Offset>[];

    for (final point in cornerPoints) {
      final double x =
          translateX(point.x.toDouble(), rotation, size, absoluteImageSize);
      final double y =
          translateY(point.y.toDouble(), rotation, size, absoluteImageSize);

      offsetPoints.add(Offset(x, y));

      // Due to possible rotations we need to find the smallest and largest
      top = min(top, y);
      bottom = max(bottom, y);
      left = min(left, x);
      right = max(right, x);
    }
    // Add the first point to close the polygon
    offsetPoints.add(offsetPoints.first);
    //canvas.drawPoints(PointMode.polygon, offsetPoints, paint);

    _drawBorderBarCode(left, top, right, bottom, colorPaint, canvas);

    /*
      canvas.drawParagraph(
        builder.build()
          ..layout(ParagraphConstraints(
            width: right - left,
          )),
        Offset(left, top),
      );
       */
  }

  void _drawBorderBarCode(double left, double top, double right, double bottom,
      Paint colorPaint, Canvas canvas) {
    left -= paddingBarcode;
    top -= paddingBarcode;
    right += paddingBarcode;
    bottom += paddingBarcode;
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
  bool shouldRepaint(BarcodeDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.barcode != barcode;
  }
}
