import 'package:go_router/go_router.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';
import 'package:radiology_and_lab_app/features/home/view/home_view.dart';
import 'package:radiology_and_lab_app/layout.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppStrings.layoutRoute,
  routes: [
    GoRoute(path: AppStrings.layoutRoute, builder: (_, _) => const AppLayout()),
    GoRoute(path: AppStrings.homeRoute, builder: (_, _) => const HomeView()),
  ],
);
