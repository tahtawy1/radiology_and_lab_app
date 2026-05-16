import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';
import 'package:radiology_and_lab_app/features/auth/presentation/widgets/auth_form_container.dart';
import 'package:radiology_and_lab_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:radiology_and_lab_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:radiology_and_lab_app/features/auth/presentation/widgets/loading_button.dart';
import 'package:radiology_and_lab_app/features/auth/presentation/widgets/login/role_selector.dart';
import 'package:radiology_and_lab_app/features/auth/presentation/widgets/password_field.dart';
import '../../../../core/validation/app_validators.dart';
import '../../../../shared/widgets/app_snackbar.dart';
import '../../../../shared/widgets/section_title.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Patient';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _selectedRole,
      );
    }
  }

  void _forgotPassword() {
    AppSnackBar.showInfo(context, 'Feature coming soon');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            AppSnackBar.showSuccess(context, 'Login Successful');
            final role = state.user.role.toLowerCase();
            if (role == 'admin') {
              // context.go(AppStrings.adminHomeRoute);
            } else if (role == 'doctor') {
              context.go(AppStrings.doctorApprovalRoute);
            } else {
              context.go(AppStrings.queuePatientRoute);
            }
          } else if (state is AuthError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const AuthHeader(
                    title: 'Welcome Back',
                    subtitle: 'Secure Medical Login',
                    icon: Icons.control_camera,
                  ),
                  AuthFormContainer(
                    children: [
                      RoleSelector(
                        selectedRole: _selectedRole,
                        onRoleChanged:
                            (role) => setState(() => _selectedRole = role),
                      ),
                      const SizedBox(height: 32),

                      const SectionTitle(title: 'Email or Username'),
                      CustomTextField(
                        controller: _emailController,
                        hint: 'Enter your email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidators.validateEmail,
                      ),
                      const SizedBox(height: 20),

                      const SectionTitle(title: 'Password'),
                      PasswordField(
                        controller: _passwordController,
                        hint: 'Enter your password',
                        validator:
                            (val) =>
                                AppValidators.validateEmpty(val, 'Password'),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: isLoading ? null : _forgotPassword,
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      LoadingButton(
                        text: 'Login',
                        isLoading: isLoading,
                        onPressed: _login,
                        icon: Icons.arrow_forward,
                      ),
                    ],
                  ),
                  _buildFooter(isLoading),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooter(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'New Patient? ',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          GestureDetector(
            onTap:
                isLoading ? null : () => context.push(AppStrings.registerRoute),
            child: const Text(
              'Register',
              style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
