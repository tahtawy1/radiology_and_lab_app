import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:radiology_and_lab_app/core/constants/app_colors.dart';

class BlurOrb extends StatelessWidget {
  const BlurOrb({
    super.key,
    this.size,
    this.width,
    this.height,
    required this.blurRadius,
  });

  final double? size;
  final double? width;
  final double? height;
  final double blurRadius;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
      child: Container(
        width: size ?? width,
        height: size ?? height,
        decoration: const BoxDecoration(
          color: AppColors.blobColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
