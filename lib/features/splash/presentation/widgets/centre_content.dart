import 'package:flutter/material.dart';
import 'package:radiology_and_lab_app/core/constants/app_text_styles.dart';
import 'package:radiology_and_lab_app/features/splash/presentation/widgets/hospital_badge.dart';
import 'package:radiology_and_lab_app/features/splash/presentation/widgets/logo_widget.dart';
import 'package:radiology_and_lab_app/features/splash/presentation/widgets/title_block.dart';

class CentreContent extends StatelessWidget {
  const CentreContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const LogoWidget(),
        const SizedBox(height: 32),
        TitleBlock(),
        const SizedBox(height: 8),
        Text('Smart Healthcare, Simplified', style: AppTypography.subtitle),
        const SizedBox(height: 24),
        const HospitalBadge(name: 'City General Hospital'),
      ],
    );
  }
}
