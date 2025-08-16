import 'package:flutter/material.dart';
import 'package:monkey_meal/core/helper/helper.dart';

import '../../../../core/consts/colors/colors.dart';
import '../../../../core/consts/functions/animations.dart';
import '../login/log_in_screen.dart';
import 'sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: Column(
            children: [
              SizedBox(height: context.getScreenHeight * 0.05),
              Text(
                'Sign Up',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.normal, fontSize: 30),
              ),
              const SizedBox(height: 10),
              const Text('Add your details to sign up', style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 40),
              const SignUpForm(),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Already have an account?", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () => NavAndAnimationsFunctions.navToWithRTLAnimation(context, LoginScreen()),
                      child: Text("Sign In", style: TextStyle(color: AppColor.orange)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
