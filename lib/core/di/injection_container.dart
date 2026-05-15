import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Splash Feature
import '../../features/splash/presentation/viewmodel/splash_cubit/splash_cubit.dart';

// Appointment Feature
import '../../features/appointment/data/datasource/appointment_remote_datasource.dart';
import '../../features/appointment/data/repositories/appointment_repository_impl.dart';
import '../../features/appointment/domain/repositories/appointment_repository.dart';
import '../../features/appointment/domain/usecases/book_appointment_usecase.dart';
import '../../features/appointment/domain/usecases/cancel_appointment_usecase.dart';
import '../../features/appointment/domain/usecases/get_all_appointments_usecase.dart';
import '../../features/appointment/domain/usecases/get_patient_appointments_usecase.dart';
import '../../features/appointment/domain/usecases/update_appointment_status_usecase.dart';
import '../../features/appointment/domain/usecases/get_doctors_usecase.dart';
import '../../features/appointment/presentation/cubit/appointment_cubit.dart';

// Auth Feature
import '../../features/auth/data/datasource/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

final getIt = GetIt.instance;

Future<void> initGetIt() async {
  // ---------------------------------------------------------------------------
  // External Services
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // ---------------------------------------------------------------------------
  // Auth Feature
  // ---------------------------------------------------------------------------
  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: getIt(), firestore: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => SignInUseCase(getIt()));
  getIt.registerLazySingleton(() => SignUpUseCase(getIt()));
  getIt.registerLazySingleton(() => SignOutUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  // Cubits
  getIt.registerFactory(
    () => AuthCubit(
      signInUseCase: getIt(),
      signUpUseCase: getIt(),
      signOutUseCase: getIt(),
      getCurrentUserUseCase: getIt(),
    ),
  );

  // ---------------------------------------------------------------------------
  // Splash Feature
  // ---------------------------------------------------------------------------
  // Cubits
  getIt.registerFactory(() => SplashCubit());

  // ---------------------------------------------------------------------------
  // Appointment Feature
  // ---------------------------------------------------------------------------
  // Data Sources
  getIt.registerLazySingleton<AppointmentRemoteDataSource>(
    () => AppointmentRemoteDataSourceImpl(firestore: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => BookAppointmentUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => CancelAppointmentUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetAllAppointmentsUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetPatientAppointmentsUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => UpdateAppointmentStatusUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetDoctorsUseCase(repository: getIt()));

  // Cubits
  getIt.registerFactory(
    () => AppointmentCubit(
      bookAppointmentUseCase: getIt(),
      cancelAppointmentUseCase: getIt(),
      getAllAppointmentsUseCase: getIt(),
      getPatientAppointmentsUseCase: getIt(),
      updateAppointmentStatusUseCase: getIt(),
      getDoctorsUseCase: getIt(),
    ),
  );
}
