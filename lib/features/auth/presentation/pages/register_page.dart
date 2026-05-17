import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';
import 'package:radiology_and_lab_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:radiology_and_lab_app/features/auth/presentation/widgets/loading_button.dart';
import 'package:radiology_and_lab_app/features/auth/presentation/widgets/password_field.dart';
import 'package:radiology_and_lab_app/features/auth/presentation/widgets/register/password_strength_indicator.dart';
import '../../../../core/validation/app_validators.dart';
import '../../../../shared/widgets/app_snackbar.dart';
import '../../../../shared/widgets/section_title.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _nationalIdController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signUp(
        fullName: _fullNameController.text.trim(),
        nationalId: _nationalIdController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            AppSnackBar.showSuccess(context, 'Registration Successful');
            context.go(AppStrings.dashboardRoute, extra: state.user);
          } else if (state is AuthError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoBanner(),
                  const SizedBox(height: 24),

                  const SectionTitle(title: 'Full Name'),
                  CustomTextField(
                    controller: _fullNameController,
                    hint: 'Enter your full name',
                    icon: Icons.person_outline,
                    validator: AppValidators.validateFullName,
                  ),
                  const SizedBox(height: 16),

                  const SectionTitle(title: 'National ID'),
                  CustomTextField(
                    controller: _nationalIdController,
                    hint: 'Enter 14-digit National ID',
                    icon: Icons.badge_outlined,
                    keyboardType: TextInputType.number,
                    validator: AppValidators.validateNationalId,
                  ),
                  const SizedBox(height: 16),

                  const SectionTitle(title: 'Phone Number'),
                  CustomTextField(
                    controller: _phoneController,
                    hint: 'e.g. 01012345678',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: AppValidators.validatePhone,
                  ),
                  const SizedBox(height: 16),

                  const SectionTitle(title: 'Email'),
                  CustomTextField(
                    controller: _emailController,
                    hint: 'ahmed@example.com',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    helperText:
                        'Email Verification - A 6-digit code will be sent',
                    validator: AppValidators.validateEmail,
                  ),
                  const SizedBox(height: 16),

                  const SectionTitle(title: 'Password'),
                  PasswordField(
                    controller: _passwordController,
                    hint: 'Enter password',
                    validator: AppValidators.validatePassword,
                    onChanged: (val) => setState(() {}),
                  ),
                  const SizedBox(height: 16),

                  PasswordStrengthIndicator(password: _passwordController.text),

                  const SizedBox(height: 32),

                  LoadingButton(
                    text: 'Create Account',
                    isLoading: isLoading,
                    onPressed: _register,
                  ),
                  const SizedBox(height: 16),

                  _buildFooter(isLoading),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.05),
        border: Border.all(
          color: AppColors.primaryLight.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.primaryDark,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Patient Registration Only',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Doctor and Admin accounts are created by the hospital administrator.',
                  style: TextStyle(color: AppColors.primaryDark, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isLoading) {
    return Column(
      children: [
        const Center(
          child: Text(
            'Only patients can register here',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already have an account? ',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            GestureDetector(
              onTap: isLoading ? null : () => context.pop(),
              child: const Text(
                'Login',
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
