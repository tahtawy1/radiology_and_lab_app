import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';
import 'package:radiology_and_lab_app/features/splash/presentation/view/splash_view.dart';
import 'package:radiology_and_lab_app/features/splash/presentation/viewmodel/splash_cubit/splash_cubit.dart';
import 'package:radiology_and_lab_app/login_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppStrings.splashRoute,
  routes: [
    GoRoute(
      path: AppStrings.splashRoute,
      builder: (_, _) => BlocProvider<SplashCubit>(
        create: (context) => SplashCubit()..splashTimer(),
        child: const SplashView(),
      ),
    ),
    GoRoute(path: AppStrings.loginRoute, builder: (_, _) => const LoginView()),
    // GoRoute(
    //   path: AppStrings.homeRoute,
    //   // builder: (_) => const _PlaceholderScreen(label: 'Home'),
    // ),
  ],
);
