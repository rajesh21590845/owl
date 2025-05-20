import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color? color;

  const CustomIcon({
  Key? key,
  required this.assetPath,
  this.size = 24.0,
  this.color,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      height: size,
      width: size,
      color: color,
    );
  }
}
