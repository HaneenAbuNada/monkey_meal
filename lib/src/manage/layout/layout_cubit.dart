import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/src/screens/app/menu/menu_screen.dart';

import '../../screens/app/account/profile_screen.dart';
import '../../screens/app/home/home_screen.dart';
import '../../screens/app/more/more_screen.dart';
import '../../screens/app/offers/offers_screen.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutInitial(2));

  static LayoutCubit get(context) => BlocProvider.of(context, listen: false);

  final List<Widget> screenOptions = [MenuView(), OfferView(), MainView(), ProfileView(), MoreView()];

  void changeTab(int index) => emit(LayoutTabChanged(index));
}
