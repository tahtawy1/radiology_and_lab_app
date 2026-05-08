import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';
import 'package:radiology_and_lab_app/features/splash/presentation/viewmodel/splash_cubit/splash_cubit.dart';
import 'package:radiology_and_lab_app/features/splash/presentation/widgets/splash_body.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is NavigateToAuth) {
          context.go(AppStrings.loginRoute);
        } else if (state is NavigateToHome) {
          //! Here home view
        }
      },
      child: const Scaffold(body: SplashBody()),
    );
  }
}
