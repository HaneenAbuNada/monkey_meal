import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/src/screens/app/layout.dart';

import '../../../../core/consts/colors/colors.dart';
import '../../../../core/consts/functions/animations.dart';
import '../../../../core/consts/validator/validation.dart';
import '../../../manage/auth_cubit/login_cubit/login_cubit.dart';
import '../../../widgets/custom_form_field/build_text_form_field_widget.dart';
import '../../../widgets/custom_snackbar/build_custom_snackbar_widget.dart';
import '../reset_password/forgot_password.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool? remember = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is SuccessLoginState) {
            showSuccessSnackBar("Login successful", 3, context);
            NavAndAnimationsFunctions.navAndFinish(context, const Layout());
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                customTextField(
                  controller: _emailController,
                  hintText: "Enter your email",
                  validator: (p0) => ValidationUtils.validateEmail(p0),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                customTextField(
                  controller: _passwordController,
                  hintText: "Enter your password",
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: (p0) => ValidationUtils.validatePassword(p0),
                ),
                const SizedBox(height: 30),

                state is LoadingLoginState
                    ? const CircularProgressIndicator()
                    : SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            debugPrint("EMAIL: ${_emailController.text.trim()}");
                            debugPrint("PASSWORD: ${_passwordController.text.trim()}");
                            debugPrint("email: $_emailController");
                            debugPrint("password: $_passwordController");
                            context.read<LoginCubit>().login(
                              context,
                              emailController: _emailController,
                              passwordController: _passwordController,
                            );
                          }
                        },
                        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColor.orange)),
                        child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () => NavAndAnimationsFunctions.navToWithRTLAnimation(context, ForgetPwScreen()),
                  child: const Text(
                    "Forget your password?",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
