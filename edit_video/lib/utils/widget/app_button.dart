import 'package:flutter/material.dart';

import '../themes/theme.dart';

class AppButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final double? minWidth;
  final double? minHeight;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final BoxBorder? border;
  final VoidCallback? onPressed;
  final Widget child;
  int eventValue = 1;

  AppButton(
      {Key? key,
      required this.onPressed,
      required this.child,
      this.borderRadius =
          const BorderRadius.all(Radius.circular(kDefaultRadius)),
      this.height = kDefaultHeight,
      this.width,
      this.minHeight,
      this.minWidth,
      this.padding = const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      this.color,
      this.border,
      this.eventValue = 1})
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
            border: border,
            borderRadius: borderRadius,
          ),
          clipBehavior: Clip.antiAlias,
          child: child),
    );
  }
}
