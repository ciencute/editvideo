import 'package:flutter/material.dart';

import '../themes/theme.dart';

class AppLinearButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final double? minWidth;
  final double? minHeight;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;
  final VoidCallback? onPressed;
  final Widget child;
  final int eventValue;
  final Color? color;

  const AppLinearButton(
      {Key? key,
      this.eventValue = 1,
      required this.onPressed,
      required this.child,
      this.borderRadius =
          const BorderRadius.all(Radius.circular(kDefaultRadius * 4)),
      this.height = kDefaultHeight,
      this.width,
      this.minHeight,
      this.color = kPrimaryLightColor,
      this.minWidth,
      this.padding = const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      this.gradient = kGradient7})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          constraints: BoxConstraints(
              minWidth: minWidth ?? 0, minHeight: minHeight ?? 0),
          width: width,
          height: height,
          padding: padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            gradient: gradient,
            borderRadius: borderRadius,
          ),
          clipBehavior: Clip.antiAlias,
          child: child),
    );
  }
}
