import 'package:flutter/material.dart';
import 'package:monkey_meal/core/consts/functions/animations.dart';
import 'package:monkey_meal/src/widgets/custom_button/build_custom_button.dart';
import 'package:monkey_meal/src/widgets/custom_form_field/build_text_form_field_widget.dart';

import '../../../../core/consts/strings/strings.dart';
import '../otp/send_otp_screen.dart';

class ForgetPwScreen extends StatelessWidget {
  const ForgetPwScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
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
                    "Reset Password",
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Please enter your email to recieve a link to create a new password via email",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 40),
                  customTextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    hintText: "Enter your email",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return kEmailNullError;
                      } else if (!emailValidatorRegExp.hasMatch(value)) {
                        return kInvalidEmailError;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  customButton(
                    press: () {
                      if (_formKey.currentState!.validate()) {
                        NavAndAnimationsFunctions.navToWithRTLAnimation(context, SendOTPScreen());
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
