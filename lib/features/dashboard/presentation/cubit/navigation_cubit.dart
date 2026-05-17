import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_state.dart';

/// Manages only the active bottom-navigation tab index.
/// No business logic belongs here.
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationIndexChanged(0));

  void goToTab(int index) => emit(NavigationIndexChanged(index));
}
