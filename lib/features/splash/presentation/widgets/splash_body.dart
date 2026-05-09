import 'package:flutter/material.dart';
import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/features/splash/presentation/view/splash_view.dart';
import 'package:radiology_and_lab_app/features/splash/presentation/widgets/centre_content.dart';
import 'package:radiology_and_lab_app/features/splash/presentation/widgets/decorative_orbs.dart';
import 'package:radiology_and_lab_app/features/splash/presentation/widgets/page_indicator.dart';

class SplashBody extends StatelessWidget {
  const SplashBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradientTop,
              AppColors.gradientMid,
              AppColors.gradientBottom,
            ],
            stops: [0.0, 0.60, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // ── Decorative blurred orbs (background layer) ─────────────────
            const DecorativeOrbs(),

            // ── Main content ───────────────────────────────────────────────
            SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Expanded(child: CentreContent()),
                    SizedBox(width: 96, child: const PageIndicator()),
                    const SizedBox(height: 64),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
