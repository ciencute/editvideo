import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'cache_iamge.dart';

class FCoreImage extends StatelessWidget {
  const FCoreImage(
      this.source, {
        Key? key,
        this.fit = BoxFit.cover,
        this.width,
        this.height,
        this.usePlaceHolder = false,
        this.color,
      }) : super(key: key);
  final String source;
  final BoxFit fit;
  final double? width;
  final double? height;
  final bool usePlaceHolder;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    if (source.contains('http')) {
      return CacheImage(
        url: source,
        fit: fit,
        width: width,
        height: height,
      );
    } else if (source.contains('.svg')) {
      return SvgPicture.asset(
        source,
        fit: fit,
        color: color,
        width: width,
        height: height,
      );
    } else {
      return Image.asset(
        source,
        fit: fit,
        width: width,
        height: height,
      );
    }
  }
}