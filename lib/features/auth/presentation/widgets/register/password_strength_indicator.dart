import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

enum PasswordStrength { none, weak, medium, strong }

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({super.key, required this.password});

  PasswordStrength _calculateStrength() {
    if (password.isEmpty) return PasswordStrength.none;
    if (password.length < 6) return PasswordStrength.weak;

    bool hasLetters = password.contains(RegExp(r'[a-zA-Z]'));
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));

    if (password.length >= 8 && hasUppercase && hasLowercase && hasDigits) {
      return PasswordStrength.strong;
    }

    if (password.length >= 6 && hasLetters) {
      return PasswordStrength.medium;
    }

    return PasswordStrength.weak;
  }

  @override
  Widget build(BuildContext context) {
    final strength = _calculateStrength();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(3, (index) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 4,
                margin: EdgeInsets.only(right: index < 2 ? 4 : 0),
                decoration: BoxDecoration(
                  color: _getBarColor(index, strength),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          _getStrengthText(strength),
          style: TextStyle(
            color: _getTextColor(strength),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getBarColor(int index, PasswordStrength strength) {
    if (strength == PasswordStrength.none) return AppColors.inputBorder;

    if (strength == PasswordStrength.weak) {
      return index == 0 ? AppColors.errorRed : AppColors.inputBorder;
    }
    if (strength == PasswordStrength.medium) {
      return index <= 1 ? Colors.orange : AppColors.inputBorder;
    }
    if (strength == PasswordStrength.strong) {
      return AppColors.successGreen;
    }
    return AppColors.inputBorder;
  }

  String _getStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.none:
        return '';
      case PasswordStrength.weak:
        return 'Weak password';
      case PasswordStrength.medium:
        return 'Medium password';
      case PasswordStrength.strong:
        return 'Strong password';
    }
  }

  Color _getTextColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.none:
        return Colors.transparent;
      case PasswordStrength.weak:
        return AppColors.errorRed;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return AppColors.successGreen;
    }
  }
}
