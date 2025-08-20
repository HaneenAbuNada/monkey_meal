import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:monkey_meal/core/helper/sqlite_helper.dart';
import 'package:monkey_meal/src/manage/auth_cubit/login_cubit/login_cubit.dart';
import 'package:monkey_meal/src/manage/auth_cubit/signup_cubit/signup_cubit.dart';
import 'package:monkey_meal/src/manage/foods/foods_cubit.dart';
import 'package:monkey_meal/src/manage/layout/layout_cubit.dart';
import 'package:monkey_meal/src/manage/onboarding/onboarding_cubit.dart';
import 'package:monkey_meal/src/manage/payment/payment_cubit.dart';
import 'package:monkey_meal/src/screens/splash/splash_screen.dart';

import 'core/consts/bloc_observer.dart';
import 'core/helper/firebase_helper.dart';
import 'core/shared_preferenced/shared_preferenced.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseServices().getFcmToken();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();
  Bloc.observer = MyBlocObserver();
  await SharedPrefController().initPreferences();
  await ScreenUtil.ensureScreenSize();
  await SqliteHelper().database;

  runApp(MyApp(isLoggedIn: SharedPrefController().isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
        BlocProvider<SignupCubit>(create: (context) => SignupCubit(FirebaseServices())),
        BlocProvider<OnboardingCubit>(create: (context) => OnboardingCubit()),
        BlocProvider<LayoutCubit>(create: (context) => LayoutCubit()),
        BlocProvider<FoodsCubit>(
          create:
              (context) =>
                  FoodsCubit()
                    ..fetchFoods()
                    ..loadOffers()
                    ..fetchUserOrders(FirebaseServices().currentUserId!),
        ),
        BlocProvider<PaymentCubit>(create: (context) => PaymentCubit()..fetchPaymentMethods()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder:
            (_, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(fontFamily: 'Metropolis', scaffoldBackgroundColor: Colors.white),
              home: SplashScreen(isLoggedIn: isLoggedIn),
              title: "Monkey Meal",
            ),
      ),
    );
  }
}
