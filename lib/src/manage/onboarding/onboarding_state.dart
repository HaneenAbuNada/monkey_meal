part of 'onboarding_cubit.dart';

abstract class OnboardingState {
  final int currentPage;

  const OnboardingState(this.currentPage);
}

class OnboardingInitial extends OnboardingState {
  OnboardingInitial(super.page);
}

class OnboardingUpdated extends OnboardingState {
  OnboardingUpdated(super.page);
}

class OnboardingCompleted extends OnboardingState {
  OnboardingCompleted() : super(-1);
}
