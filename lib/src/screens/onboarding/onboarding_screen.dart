import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/src/widgets/custom_button/build_custom_button.dart';

import '../../../core/consts/colors/colors.dart';
import '../../../core/consts/functions/animations.dart';
import '../../manage/onboarding/onboarding_cubit.dart';
import '../app/layout.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  final double _indicatorSize = 5.0;
  final Duration _pageTransitionDuration = const Duration(milliseconds: 300);
  final Curve _pageTransitionCurve = Curves.easeIn;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingCompleted) {
            NavAndAnimationsFunctions.navAndFinish(context, const Layout());
          }
        },
        builder: (context, state) {
          final cubit = context.read<OnboardingCubit>();
          return _buildOnboardingContent(context, cubit, state.currentPage);
        },
      ),
    );
  }

  Widget _buildOnboardingContent(BuildContext context, OnboardingCubit cubit, int currentPage) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const Spacer(),
                _buildPageViewWithText(context, cubit),
                _buildNavigationButton(cubit, currentPage),
                const Spacer(),
              ],
            ),
            Align(alignment: Alignment(0.0, 0.2), child: _buildPageIndicators(cubit, currentPage)),
          ],
        ),
      ),
    );
  }

  Widget _buildPageViewWithText(BuildContext context, OnboardingCubit cubit) => SizedBox(
    height: 500,
    child: PageView.builder(
      controller: _pageController,
      onPageChanged: cubit.goToPage,
      itemCount: cubit.pages.length,
      itemBuilder: (context, index) {
        final pageData = cubit.pages[index];
        return Column(
          children: [
            Expanded(flex: 5, child: Image.asset('assets/images/${pageData["image"]!}', fit: BoxFit.contain)),
            Spacer(),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: Text(
                      pageData["title"]!,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: Text(
                      pageData["desc"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  Widget _buildPageIndicators(OnboardingCubit cubit, int currentPage) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(cubit.pages.length, (index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.5),
        child: CircleAvatar(
          radius: _indicatorSize,
          backgroundColor: currentPage == index ? AppColor.orange : AppColor.placeholder,
        ),
      );
    }),
  );

  Widget _buildNavigationButton(OnboardingCubit cubit, int currentPage) {
    final isLastPage = currentPage == cubit.pages.length - 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: customButton(
        press: () {
          if (isLastPage) {
            cubit.completeOnboarding();
          } else {
            cubit.nextPage();
            _pageController.nextPage(duration: _pageTransitionDuration, curve: _pageTransitionCurve);
          }
        },
        title: isLastPage ? "Get Started" : "Next",
      ),
    );
  }
}
