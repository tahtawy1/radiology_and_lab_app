abstract class NavigationState {
  const NavigationState();
}

class NavigationIndexChanged extends NavigationState {
  final int index;
  const NavigationIndexChanged(this.index);
}
