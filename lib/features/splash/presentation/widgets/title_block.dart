import 'package:flutter/material.dart';
import 'package:radiology_and_lab_app/core/constants/app_text_styles.dart';

class TitleBlock extends StatelessWidget {
  const TitleBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Radiology & Lab', style: AppTypography.titleBold),
        Text('System', style: AppTypography.titleLight),
      ],
    );
  }
}
