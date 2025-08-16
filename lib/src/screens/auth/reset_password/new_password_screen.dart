import 'package:flutter/material.dart';
import 'package:monkey_meal/core/consts/functions/animations.dart';
import 'package:monkey_meal/src/screens/auth/landing/landing_screen.dart';
import 'package:monkey_meal/src/widgets/custom_button/build_custom_button.dart';
import 'package:monkey_meal/src/widgets/custom_form_field/build_text_form_field_widget.dart';
import 'package:monkey_meal/src/widgets/custom_snackbar/build_custom_snackbar_widget.dart';

class NewPwScreen extends StatelessWidget {
  const NewPwScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "New Password",
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Please enter your email to receive a \nlink to  create a new password via email",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 40),
                  customTextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: passwordController,
                    hintText: "Enter your new password",
                  ),
                  SizedBox(height: 20),
                  customTextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: confirmPasswordController,
                    hintText: "confirm your new password",
                  ),
                  SizedBox(height: 30),
                  customButton(
                    press: () {
                      if (_formKey.currentState!.validate()) {
                        showSuccessSnackBar("Done! now login or create an account", 3, context);
                        NavAndAnimationsFunctions.navAndFinish(context, LandingScreen());
                      }
                    },
                    title: "Send",
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
