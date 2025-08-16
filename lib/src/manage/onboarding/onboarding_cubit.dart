import 'package:bloc/bloc.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial(0));

  final int totalPages = 3;

  final List<Map<String, String>> pages = [
    {
      "image": "first.png",
      "title": "Find Food You Love",
      "desc": "Discover the best foods from over 1,000 restaurants and fast delivery to your doorstep",
    },
    {"image": "sec.png", "title": "Fast Delivery", "desc": "Fast food delivery to your home, office wherever you are"},
    {
      "image": "third.png",
      "title": "Live Tracking",
      "desc": "Real time tracking of your food on the app once you placed the order",
    },
  ];

  void nextPage() {
    if (state.currentPage < totalPages - 1) {
      emit(OnboardingUpdated(state.currentPage + 1));
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      emit(OnboardingUpdated(state.currentPage - 1));
    }
  }

  void goToPage(int page) {
    if (page >= 0 && page < totalPages) {
      emit(OnboardingUpdated(page));
    }
  }

  void completeOnboarding() {
    emit(OnboardingCompleted());
  }
}
