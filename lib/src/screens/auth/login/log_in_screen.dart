import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/core/consts/functions/animations.dart';
import 'package:monkey_meal/core/helper/helper.dart';
import 'package:monkey_meal/src/manage/auth_cubit/signup_cubit/signup_cubit.dart';
import 'package:monkey_meal/src/screens/onboarding/onboarding_screen.dart';
import 'package:monkey_meal/src/widgets/custom_snackbar/build_custom_snackbar_widget.dart';

import '../../../../core/consts/colors/colors.dart';
import 'log_in_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: context.getScreenHeight,
          width: context.getScreenWidth,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: context.getScreenHeight * 0.05),
                  Text(
                    "Login",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'assets/fonts/Metropolis-ExtraBold.ttf',
                      fontSize: 30,
                      color: Color(0xFF4A4B4D),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Add your details to login',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'assets/fonts/Metropolis-Medium.ttf',
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  const LoginForm(),
                  const Spacer(flex: 2),
                  const Text("or Login With", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color(0xFF367FC0))),
                      onPressed: () {
                        // Logique pour la connexion avec Facebook
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/fb.png', height: 24, width: 24),
                          const SizedBox(width: 30),
                          const Text(
                            "Login with Facebook",
                            style: TextStyle(color: Colors.white, fontFamily: 'assets/fonts/Metropolis-Medium.ttf'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  BlocListener<SignupCubit, SignupState>(
                    listener: (context, state) {
                      if (state is SignupSuccess) {
                        NavAndAnimationsFunctions.navAndFinish(context, OnboardingScreen());
                      } else if (state is SignupError) {
                        showErrorSnackBar("Error, Try again", 2, context);
                      }
                    },
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color(0xFFDD4B39))),
                        onPressed: () {
                          context.read<SignupCubit>().signInWithGoogle();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/google.png', height: 24, width: 24),
                            const SizedBox(width: 30),
                            const Text(
                              "Login with Google",
                              style: TextStyle(color: Colors.white, fontFamily: 'assets/fonts/Metropolis-Medium.ttf'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an Account?",
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () => NavAndAnimationsFunctions.navToWithRTLAnimation(context, LoginScreen()),
                          child: Text("Sign Up", style: TextStyle(color: AppColor.orange)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
