import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';
import 'package:radiology_and_lab_app/core/di/injection_container.dart';
import 'package:radiology_and_lab_app/features/auth/domain/entities/user_entity.dart';
import 'package:radiology_and_lab_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:radiology_and_lab_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:radiology_and_lab_app/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:radiology_and_lab_app/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:radiology_and_lab_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:radiology_and_lab_app/features/splash/presentation/view/splash_view.dart';
import 'package:radiology_and_lab_app/features/splash/presentation/viewmodel/splash_cubit/splash_cubit.dart';
import 'package:radiology_and_lab_app/features/auth/presentation/pages/login_page.dart';
import 'package:radiology_and_lab_app/features/auth/presentation/pages/register_page.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/pages/patint/book_appointment_screen.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/pages/patint/my_appointments_screen.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/pages/doctor/doctor_approval_screen.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/cubit/appointment_cubit.dart';
import 'package:radiology_and_lab_app/features/queue/presentation/pages/admin/queue_admin_screen.dart';
import 'package:radiology_and_lab_app/features/queue/presentation/cubit/queue_admin_cubit.dart';
import 'package:radiology_and_lab_app/features/queue/presentation/pages/patient/queue_patient_screen.dart';
import 'package:radiology_and_lab_app/features/queue/presentation/cubit/queue_patient_cubit.dart';
import 'package:radiology_and_lab_app/features/dashboard/presentation/pages/main_dashboard_screen.dart';
import 'package:radiology_and_lab_app/features/dashboard/presentation/pages/doctor/doctor_notifications_screen.dart';
AuthCubit _buildAuthCubit() => AuthCubit(
      signInUseCase: getIt<SignInUseCase>(),
      signUpUseCase: getIt<SignUpUseCase>(),
      signOutUseCase: getIt<SignOutUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
    );

final GoRouter appRouter = GoRouter(
  initialLocation: AppStrings.splashRoute,
  routes: [
    // ── Splash ────────────────────────────────────────────────────────────────
    GoRoute(
      path: AppStrings.splashRoute,
      builder: (_, __) => BlocProvider<SplashCubit>(
        create: (_) => SplashCubit()..splashTimer(),
        child: const SplashView(),
      ),
    ),

    // ── Auth ──────────────────────────────────────────────────────────────────
    GoRoute(
      path: AppStrings.loginRoute,
      builder: (_, __) => BlocProvider<AuthCubit>(
        create: (_) => _buildAuthCubit(),
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: AppStrings.registerRoute,
      builder: (_, __) => BlocProvider<AuthCubit>(
        create: (_) => _buildAuthCubit(),
        child: const RegisterPage(),
      ),
    ),

    // ── Dashboard (role-aware entry point) ────────────────────────────────────
    GoRoute(
      path: AppStrings.dashboardRoute,
      builder: (_, state) {
        // Fallback for direct navigation without user extra
        if (state.extra == null) {
          return const Scaffold(
            body: Center(child: Text('Error: No user session found. Please login again.')),
          );
        }
        final user = state.extra as UserEntity;
        return BlocProvider<AuthCubit>(
          create: (_) => _buildAuthCubit(),
          child: MainDashboardScreen(user: user),
        );
      },
    ),

    // ── Standalone routes (deep-link / backward-compat) ───────────────────────
    GoRoute(
      path: AppStrings.bookAppointmentRoute,
      builder: (_, __) => BlocProvider<AppointmentCubit>(
        create: (_) => getIt<AppointmentCubit>(),
        child: const BookAppointmentScreen(),
      ),
    ),
    GoRoute(
      path: AppStrings.myAppointmentsRoute,
      builder: (_, __) => BlocProvider<AppointmentCubit>(
        create: (_) => getIt<AppointmentCubit>(),
        child: const MyAppointmentsScreen(),
      ),
    ),
    GoRoute(
      path: AppStrings.doctorApprovalRoute,
      builder: (_, __) => BlocProvider<AppointmentCubit>(
        create: (_) => getIt<AppointmentCubit>(),
        child: const DoctorApprovalScreen(),
      ),
    ),
    GoRoute(
      path: AppStrings.queueAdminRoute,
      builder: (_, __) => BlocProvider<QueueAdminCubit>(
        create: (_) => getIt<QueueAdminCubit>(),
        child: const QueueAdminView(),
      ),
    ),
    GoRoute(
      path: AppStrings.queuePatientRoute,
      builder: (_, __) => BlocProvider<QueuePatientCubit>(
        create: (_) => getIt<QueuePatientCubit>(),
        child: const QueuePatientView(),
      ),
    ),
    GoRoute(
      path: AppStrings.notificationsRoute,
      builder: (_, __) => const DoctorNotificationsScreen(),
    ),
  ],
);
