import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:radiology_and_lab_app/core/services/user_session_service.dart';
import 'package:radiology_and_lab_app/features/auth/data/models/user_model.dart';
import 'package:radiology_and_lab_app/features/auth/domain/entities/user_entity.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  SplashCubit({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        super(SplashInitial());

  /// Called once on app launch. Shows splash for at least [_minDisplayMs]
  /// milliseconds, then navigates to the correct screen.
  Future<void> splashTimer() async {
    emit(SplashLoadingState());

    const minDisplayMs = 2000; // keep splash visible for UX
    final start = DateTime.now();

    UserEntity? restoredUser;

    try {
      final firebaseUser = _auth.currentUser;

      if (firebaseUser != null) {
        // Re-hydrate the Firestore profile
        final doc = await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (doc.exists && doc.data() != null) {
          final model = UserModel.fromJson(doc.data()!);
          UserSessionService.currentUser = model;
          restoredUser = model;
        }
      }
    } catch (_) {
      // If something fails during session restore, fall through to login
    }

    // Ensure the splash is shown for at least [minDisplayMs] ms
    final elapsed = DateTime.now().difference(start).inMilliseconds;
    if (elapsed < minDisplayMs) {
      await Future.delayed(Duration(milliseconds: minDisplayMs - elapsed));
    }

    if (restoredUser != null) {
      emit(NavigateToHome(restoredUser));
    } else {
      emit(NavigateToAuth());
    }
  }
}
