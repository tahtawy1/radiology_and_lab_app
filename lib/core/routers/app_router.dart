import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';
import 'package:radiology_and_lab_app/core/di/injection_container.dart';
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
import 'package:radiology_and_lab_app/features/results/presentation/cubit/results_cubit.dart';
import 'package:radiology_and_lab_app/features/results/presentation/pages/admin/upload_result_screen.dart';
import 'package:radiology_and_lab_app/features/results/presentation/pages/admin/served_patients_results_screen.dart';
import 'package:radiology_and_lab_app/features/results/presentation/pages/patient/patient_results_screen.dart';
import 'package:radiology_and_lab_app/features/results/presentation/pages/doctor/review_result_screen.dart';
import 'package:radiology_and_lab_app/features/results/domain/entites/result_entity.dart';
import 'package:radiology_and_lab_app/features/results/presentation/pages/doctor/doctor_pending_reviews_screen.dart';
import 'package:radiology_and_lab_app/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:radiology_and_lab_app/features/notifications/presentation/cubit/notifications_cubit.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppStrings.loginRoute,
  routes: [
    GoRoute(
      path: AppStrings.splashRoute,
      builder:
          (_, _) => BlocProvider<SplashCubit>(
            create: (context) => SplashCubit()..splashTimer(),
            child: const SplashView(),
          ),
    ),
    GoRoute(
      path: AppStrings.loginRoute,
      builder:
          (_, _) => BlocProvider<AuthCubit>(
            create:
                (context) => AuthCubit(
                  signInUseCase: getIt<SignInUseCase>(),
                  signUpUseCase: getIt<SignUpUseCase>(),
                  signOutUseCase: getIt<SignOutUseCase>(),
                  getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
                ),
            child: const LoginPage(),
          ),
    ),
    GoRoute(
      path: AppStrings.registerRoute,
      builder:
          (_, _) => BlocProvider<AuthCubit>(
            create:
                (context) => AuthCubit(
                  signInUseCase: getIt<SignInUseCase>(),
                  signUpUseCase: getIt<SignUpUseCase>(),
                  signOutUseCase: getIt<SignOutUseCase>(),
                  getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
                ),
            child: const RegisterPage(),
          ),
    ),
    // GoRoute(
    //   path: AppStrings.homeRoute,
    // builder: (_) => const _PlaceholderScreen(label: 'Home'),
    // ),
    GoRoute(
      path: AppStrings.bookAppointmentRoute,
      builder:
          (_, _) => BlocProvider<AppointmentCubit>(
            create: (context) => getIt<AppointmentCubit>(),
            child: const BookAppointmentScreen(),
          ),
    ),
    GoRoute(
      path: AppStrings.myAppointmentsRoute,
      builder:
          (_, _) => BlocProvider<AppointmentCubit>(
            create: (context) => getIt<AppointmentCubit>(),
            child: const MyAppointmentsScreen(),
          ),
    ),
    GoRoute(
      path: AppStrings.doctorApprovalRoute,
      builder:
          (_, _) => BlocProvider<AppointmentCubit>(
            create: (context) => getIt<AppointmentCubit>(),
            child: const DoctorApprovalScreen(),
          ),
    ),

    GoRoute(
      path: AppStrings.queueAdminRoute,
      builder:
          (_, _) => BlocProvider<QueueAdminCubit>(
            create: (context) => getIt<QueueAdminCubit>(),
            child: const QueueAdminView(),
          ),
    ),
    GoRoute(
      path: AppStrings.queuePatientRoute,
      builder:
          (_, _) => BlocProvider<QueuePatientCubit>(
            create: (context) => getIt<QueuePatientCubit>(),
            child: const QueuePatientView(),
          ),
    ),

    // Results Feature Routes
    GoRoute(
      path: AppStrings.uploadResultRoute,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        if (extra == null) {
          return const Scaffold(
            body: Center(child: Text('No upload data found')),
          );
        }

        return BlocProvider<ResultsCubit>(
          create: (context) => getIt<ResultsCubit>(),
          child: UploadResultScreen(
            appointmentId: extra['appointmentId'],
            patientName: extra['patientName'],
            testType: extra['testType'],
          ),
        );
      },
    ),

    GoRoute(
      path: AppStrings.servedPatientsResultsRoute,
      builder:
          (_, _) => BlocProvider<ResultsCubit>(
            create: (context) => getIt<ResultsCubit>(),
            child: const ServedPatientsResultsScreen(),
          ),
    ),

    GoRoute(
      path: AppStrings.patientResultsRoute,
      builder:
          (_, _) => BlocProvider<ResultsCubit>(
            create: (context) => getIt<ResultsCubit>(),
            child: const PatientResultsScreen(),
          ),
    ),
    GoRoute(
      path: AppStrings.reviewResultRoute,
      builder: (context, state) {
        final result = state.extra;

        if (result == null || result is! ResultEntity) {
          return const Scaffold(body: Center(child: Text('Result not found')));
        }
        return BlocProvider<ResultsCubit>(
          create: (context) => getIt<ResultsCubit>(),
          child: ReviewResultScreen(result: result),
        );
      },
    ),
    GoRoute(
      path: AppStrings.doctorPendingReviewsRoute,
      builder:
          (_, _) => BlocProvider<ResultsCubit>(
            create: (context) => getIt<ResultsCubit>(),
            child: const DoctorPendingReviewsScreen(),
          ),
    ),

    // Notifications Feature Route
    GoRoute(
      path: AppStrings.notificationsRoute,
      builder:
          (_, _) => BlocProvider<NotificationsCubit>(
            create: (context) => getIt<NotificationsCubit>(),
            child: const NotificationsScreen(),
          ),
    ),
  ],
);
