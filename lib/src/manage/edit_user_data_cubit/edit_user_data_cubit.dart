import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/helper/firebase_helper.dart';

part 'edit_user_data_state.dart';

class EditUserDataCubit extends Cubit<EditUserDataState> {
  File? profileImage;

  EditUserDataCubit() : super(EditUserInitial());

  static EditUserDataCubit get(context) => BlocProvider.of(context, listen: false);

  Future<void> loadUserData() async {
    emit(LoadingGetUserDataFromFirebaseState());
    try {
      final uid = FirebaseServices().currentUserId;
      if (uid == null) throw Exception("User not logged in");

      final currentUser = await FirebaseServices().getUser(uid);

      emit(
        SuccessGetUserDataFromFirebaseState(
          name: currentUser.name,
          email: currentUser.email,
          phone: currentUser.phone ?? '',
          address: currentUser.address ?? '',
          image: currentUser.imageUrl,
        ),
      );
    } catch (e) {
      emit(FailedGetUserDataFromFirebaseState(e.toString()));
    }
  }

  Future<void> pickImage() async {
    if (!await _checkPermissions()) {
      emit(EditUserError('Storage permission denied'));
      return;
    }
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressQuality: 85,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 2),
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            cropStyle: CropStyle.circle,
            initAspectRatio: CropAspectRatioPreset.ratio4x3,
            lockAspectRatio: true,
            hideBottomControls: true,
            showCropGrid: false,
          ),
        ],
      );

      if (croppedFile != null) {
        profileImage = File(croppedFile.path);
        emit(EditUserImagePicked(profileImage!));
      }
    } catch (e) {
      debugPrint('Image cropping error: $e');
      emit(EditUserError('Failed to crop image: ${e.toString()}'));
    }
  }

  Future<void> updateUserData({
    required String userId,
    required String name,
    required String email,
    String? phone,
    String? address,
  }) async {
    emit(EditUserLoading());
    try {
      Map<String, dynamic> updateData = {
        'name': name,
        'email': email,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
        if (profileImage != null) 'imageUrl': profileImage!.path,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseServices().usersCollection.doc(userId).update(updateData);

      emit(EditUserSuccess());
    } catch (e) {
      emit(EditUserError(e.toString()));
    }
  }

  Future<bool> _checkPermissions() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }
}
