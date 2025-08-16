import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/src/screens/app/account/profile_form_widget.dart';
import 'package:monkey_meal/src/widgets/custom_appbar/build_appbar.dart';
import 'package:monkey_meal/src/widgets/custom_snackbar/build_custom_snackbar_widget.dart';

import '../../../../core/consts/colors/colors.dart';
import '../../../manage/edit_user_data_cubit/edit_user_data_cubit.dart';

class ProfileView extends StatelessWidget {
  static String routeName = '/profile';

  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => EditUserDataCubit()..loadUserData(), child: const _ProfileViewContent());
  }
}

class _ProfileViewContent extends StatefulWidget {
  const _ProfileViewContent();

  @override
  State<_ProfileViewContent> createState() => _ProfileViewContentState();
}

class _ProfileViewContentState extends State<_ProfileViewContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, title: "Profile"),
      body: BlocConsumer<EditUserDataCubit, EditUserDataState>(
        listener: (context, state) {
          if (state is EditUserError) {
            showErrorSnackBar(state.message, 3, context);
          } else if (state is EditUserSuccess) {
            showSuccessSnackBar('Profile updated successfully', 3, context);
          } else if (state is FailedGetUserDataFromFirebaseState) {
            showErrorSnackBar(state.message, 3, context);
          }
        },
        builder: (context, state) {
          if (state is LoadingGetUserDataFromFirebaseState) {
            return const Center(child: CircularProgressIndicator());
          }

          final cubit = context.read<EditUserDataCubit>();
          String name = '';
          String email = '';
          String phone = '';
          String address = '';
          String? imageUrl;

          if (state is SuccessGetUserDataFromFirebaseState) {
            name = state.name;
            email = state.email;
            phone = state.phone;
            address = state.address;
            imageUrl = state.image;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => cubit.pickImage(),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    child:
                    cubit.profileImage != null
                        ? ClipOval(
                      child: Image.file(cubit.profileImage!, width: 100, height: 100, fit: BoxFit.cover),
                    )
                        : (state is SuccessGetUserDataFromFirebaseState &&
                        state.image != null &&
                        state.image!.isNotEmpty
                        ? (state.image!.startsWith('http')
                        ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: state.image!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    )
                        : ClipOval(
                      child: Image.file(
                        File(state.image!),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ))
                        : const Icon(Icons.camera_alt, size: 40)),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => cubit.pickImage(),
                  child: Row(
                    spacing: 2,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, size: 16, color: AppColor.orange),
                      Text('Edit Profile', style: TextStyle(color: AppColor.orange, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('Hi there ${name.split(' ').first}!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                ProfileForm(initialName: name, initialEmail: email, initialPhone: phone, initialAddress: address),
              ],
            ),
          );
        },
      ),
    );
  }
}