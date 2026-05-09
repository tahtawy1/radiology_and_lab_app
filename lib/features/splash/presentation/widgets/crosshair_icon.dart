import 'package:flutter/material.dart';

/// Crosshair / radiology icon built from Flutter primitives –
/// matches the SVG icon in the Figma file.
class CrosshairIcon extends StatelessWidget {
  const CrosshairIcon({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Image.asset('assets/images/logo.png'),
    );
  }
}
