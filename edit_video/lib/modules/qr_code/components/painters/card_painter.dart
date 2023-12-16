import 'package:flutter/material.dart';

class CardPainter extends CustomPainter {
  final double _cardRatios = 0.6; // 56mm:92mm

  @override
  void paint(Canvas canvas, Size size) {
    double horizontalPadding = 20.0;
    double width = size.width - horizontalPadding * 2;
    double height = size.width * _cardRatios;
    double halfCardHeight = height / 2;
    double centerHeight = size.height / 2 - horizontalPadding;

    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    Path path = Path();
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(horizontalPadding, centerHeight - halfCardHeight, width, height),
        const Radius.circular(16)));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
