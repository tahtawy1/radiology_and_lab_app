import 'package:flutter/material.dart';
import 'package:radiology_and_lab_app/features/splash/presentation/widgets/blur_orb.dart';

class DecorativeOrbs extends StatelessWidget {
  const DecorativeOrbs({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top-left orb
        Positioned(
          top: 40,
          left: -40,
          child: BlurOrb(size: 160, blurRadius: 20),
        ),
        // Right-centre orb
        Positioned(
          top: MediaQuery.of(context).size.height * 0.3333,
          right: -80,
          child: BlurOrb(
            width: 240,
            height: MediaQuery.of(context).size.height * 0.2857,
            blurRadius: 32,
          ),
        ),
        // Bottom-left orb
        Positioned(
          bottom: 160,
          left: 40,
          child: BlurOrb(size: 128, blurRadius: 20),
        ),
      ],
    );
  }
}
