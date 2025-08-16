import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/core/helper/firebase_helper.dart';
import 'package:monkey_meal/src/screens/onboarding/onboarding_screen.dart';
import 'package:monkey_meal/src/widgets/custom_button/build_custom_button.dart';
import 'package:monkey_meal/src/widgets/custom_snackbar/build_custom_snackbar_widget.dart';

import '../../../../core/consts/colors/colors.dart';
import '../../../../core/consts/functions/animations.dart';
import '../../../../core/consts/validator/validation.dart';
import '../../../manage/auth_cubit/signup_cubit/signup_cubit.dart';
import '../../../widgets/custom_form_field/build_text_form_field_widget.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(FirebaseServices()),
      child: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            NavAndAnimationsFunctions.navAndFinish(context, OnboardingScreen());
            // NavAndAnimationsFunctions.navAndFinish(context, Layout());
          } else if (state is SignupError) {
            showErrorSnackBar(state.message, 3, context);
          }
        },
        builder: (context, state) {
          final cubit = context.read<SignupCubit>();

          return Form(
            key: _formKey,
            child: Column(
              children: [
                customTextField(
                  controller: _nameController,
                  hintText: 'Name',
                  validator: (value) => ValidationUtils.validateName(value),
                ),
                const SizedBox(height: 20),
                customTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => ValidationUtils.validateEmail(value),
                ),
                const SizedBox(height: 20),
                customTextField(
                  controller: _phoneController,
                  hintText: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  validator: (value) => ValidationUtils.validatePhone(value),
                ),
                const SizedBox(height: 20),
                customTextField(
                  controller: _addressController,
                  hintText: 'Address',
                  validator: (value) => ValidationUtils.validateAddress(value),
                ),
                const SizedBox(height: 20),
                customTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: !cubit.isPasswordVisible,
                  suffixWidget: IconButton(
                    icon: Icon(
                      cubit.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColor.orange,
                    ),
                    onPressed: cubit.togglePasswordVisibility,
                  ),
                  validator: (value) => ValidationUtils.validatePassword(value),
                ),
                const SizedBox(height: 20),
                customTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: !cubit.isPasswordVisible,
                  suffixWidget: IconButton(
                    icon: Icon(
                      cubit.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColor.orange,
                    ),
                    onPressed: cubit.togglePasswordVisibility,
                  ),
                  validator: (value) => ValidationUtils.validateConfirmPassword(value, _passwordController.text),
                ),
                const SizedBox(height: 30),
                state is SignupLoading
                    ? CircularProgressIndicator()
                    : customButton(press: () => _submitForm(cubit), title: "Sign Up"),
              ],
            ),
          );
        },
      ),
    );
  }

  void _submitForm(SignupCubit cubit) {
    if (_formKey.currentState!.validate()) {
      cubit.signUpWithEmail(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );
    }
  }
}
