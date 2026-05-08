import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());
  Future<void> splashTimer() async {
    emit(SplashLoadingState());
    //! Here must check auth status
    await Future.delayed(const Duration(milliseconds: 1500));
    emit(NavigateToAuth());
    // emit(NavigateToHome());
  }
}
