part of 'splash_cubit.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

class SplashLoadingState extends SplashState {}

class NavigateToAuth extends SplashState {}

class NavigateToHome extends SplashState {
  final UserEntity user;
  NavigateToHome(this.user);
}
