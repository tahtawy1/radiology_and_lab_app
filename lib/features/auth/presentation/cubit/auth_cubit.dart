import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthCubit({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial());

  // ── Failure mapper ─────────────────────────────────────────────────────────
  Failure _mapExceptionToFailure(dynamic e) {
    if (e is AuthException) {
      return AuthFailure(e.message);
    } else if (e is ValidationException) {
      return ValidationFailure(e.message);
    } else if (e is NetworkException) {
      return NetworkFailure(e.message);
    } else if (e is ServerException) {
      return ServerFailure(e.message);
    }
    return ServerFailure(e.toString());
  }

  // ── Check Auth Status ──────────────────────────────────────────────────────
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    try {
      final user = await getCurrentUserUseCase();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      final failure = _mapExceptionToFailure(e);
      emit(AuthError(failure.message));
    }
  }

  // ── Sign In ────────────────────────────────────────────────────────────────
  Future<void> signIn(
    String email,
    String password,
    String selectedRole,
  ) async {
    emit(AuthLoading());
    try {
      final user = await signInUseCase(email, password, selectedRole);
      emit(Authenticated(user));
    } catch (e) {
      final failure = _mapExceptionToFailure(e);
      emit(AuthError(failure.message));
    }
  }

  // ── Sign Up ────────────────────────────────────────────────────────────────
  Future<void> signUp({
    required String fullName,
    required String nationalId,
    required String phone,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final user = await signUpUseCase(
        email: email,
        password: password,
        fullName: fullName,
        nationalId: nationalId,
        phone: phone,
      );
      emit(Authenticated(user));
    } catch (e) {
      final failure = _mapExceptionToFailure(e);
      emit(AuthError(failure.message));
    }
  }

  // ── Sign Out ───────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await signOutUseCase();
      emit(Unauthenticated());
    } catch (e) {
      final failure = _mapExceptionToFailure(e);
      emit(AuthError(failure.message));
    }
  }
}
