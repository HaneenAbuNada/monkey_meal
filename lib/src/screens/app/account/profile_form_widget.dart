import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/core/consts/strings/strings.dart';
import 'package:monkey_meal/src/widgets/custom_button/build_custom_button.dart';
import 'package:monkey_meal/src/widgets/custom_form_field/build_text_form_field_widget.dart';

import '../../../../core/helper/firebase_helper.dart';
import '../../../manage/edit_user_data_cubit/edit_user_data_cubit.dart';

class ProfileForm extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialPhone;
  final String initialAddress;

  const ProfileForm({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.initialPhone,
    required this.initialAddress,
  });

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.initialName);
  late final _emailController = TextEditingController(text: widget.initialEmail);
  late final _phoneController = TextEditingController(text: widget.initialPhone);
  late final _addressController = TextEditingController(text: widget.initialAddress);
  // final _passwordController = TextEditingController();
  // final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    // _passwordController.dispose();
    // _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditUserDataCubit>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          customTextField(
            hintText: 'Full Name',
            controller: _nameController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          customTextField(
            hintText: 'Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return kEmailNullError;
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                return kInvalidEmailError;
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          customTextField(
            hintText: 'Phone Number',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          customTextField(
            hintText: 'Address',
            controller: _addressController,
            keyboardType: TextInputType.streetAddress,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          const SizedBox(height: 20),
          BlocBuilder<EditUserDataCubit, EditUserDataState>(
            builder: (context, state) {
              return state is EditUserLoading
                  ? CircularProgressIndicator()
                  : customButton(
                title: 'Save',
                press: () {
                  // if (_formKey.currentState!.validate()) {
                    final userId = FirebaseServices().currentUserId;
                    if (userId != null) {
                      cubit.updateUserData(
                        userId: userId,
                        name: _nameController.text,
                        email: _emailController.text,
                        phone: _phoneController.text,
                        address: _addressController.text,
                      );
                    }
                  // }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}