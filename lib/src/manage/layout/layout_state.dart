part of 'layout_cubit.dart';

abstract class LayoutState {
  final int currentTab;

  const LayoutState(this.currentTab);
}

class LayoutInitial extends LayoutState {
  LayoutInitial(super.tab);
}

class LayoutTabChanged extends LayoutState {
  LayoutTabChanged(super.tab);
}
