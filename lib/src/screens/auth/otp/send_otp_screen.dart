import 'package:flutter/material.dart';
import 'package:monkey_meal/core/consts/functions/animations.dart';
import 'package:monkey_meal/src/screens/auth/reset_password/new_password_screen.dart';
import 'package:monkey_meal/src/widgets/custom_button/build_custom_button.dart';
import 'package:monkey_meal/src/widgets/custom_snackbar/build_custom_snackbar_widget.dart';

import '../../../../core/consts/colors/colors.dart';

class SendOTPScreen extends StatefulWidget {
  const SendOTPScreen({super.key});

  @override
  State<SendOTPScreen> createState() => _SendOTPScreenState();
}

class _SendOTPScreenState extends State<SendOTPScreen> {
  final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleOTPInput(int index, String value) {
    if (value.length == 1 && index < 3) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'We have sent you an OTP to your Mobile',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  "Please check your mobile number 071*****12 continue to reset your password",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    4,
                    (index) => OTPInput(
                      controller: _otpControllers[index],
                      focusNode: _otpFocusNodes[index],
                      onChanged: (value) => _handleOTPInput(index, value),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                customButton(
                  press: () {
                    final otp = _otpControllers.map((c) => c.text).join();
                    if (otp.length == 4) {
                      NavAndAnimationsFunctions.navAndFinish(context, const NewPwScreen());
                    } else {
                      showErrorSnackBar("Complete the fields!", 3, context);
                    }
                  },
                  title: "Next",
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Didn't Recieve?"),
                    TextButton(
                      child: Text("Click Here", style: TextStyle(color: AppColor.orange, fontWeight: FontWeight.bold)),
                      onPressed: () => showSuccessSnackBar("The password: 1234", 3, context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OTPInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;

  const OTPInput({super.key, required this.controller, required this.focusNode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: ShapeDecoration(
        color: AppColor.placeholderBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Stack(
        children: [
          if (controller.text.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 20),
              child: Text("", style: TextStyle(fontSize: 45, color: Colors.grey.shade600)),
            ),
          TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: const TextStyle(fontSize: 24),
            decoration: const InputDecoration(counterText: '', border: InputBorder.none),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
