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
  ],
);
