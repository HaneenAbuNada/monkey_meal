import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/src/manage/layout/layout_cubit.dart';
import 'package:monkey_meal/src/widgets/custom_bottom_nav_bar/build_custom_bottom_nav_bar_widget.dart';

class Layout extends StatelessWidget {
  const Layout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit(),
      child: BlocBuilder<LayoutCubit, LayoutState>(
        builder: (context, state) {
          final cubit = LayoutCubit.get(context);
          return SafeArea(
            bottom: false,
            child: Scaffold(
              body: cubit.screenOptions[state.currentTab],
              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: state.currentTab,
                onTap: (p0) => cubit.changeTab(p0),
              ),
            ),
          );
        },
      ),
    );
  }
}
