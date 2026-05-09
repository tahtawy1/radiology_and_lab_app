import 'package:flutter/material.dart';
import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/features/auth/presentation/widgets/custom_text_field.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const PasswordField({
    super.key,
    required this.controller,
    required this.hint,
    this.validator,
    this.onChanged,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      hint: widget.hint,
      icon: Icons.lock_outline,
      obscureText: _obscureText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.textSecondary,
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      ),
    );
  }
}
