import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/core/helper/firebase_helper.dart';

import '../../../../core/shared_preferenced/shared_preferenced.dart';
import '../../../model/user_model.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final FirebaseServices _firebaseServices;

  SignupCubit(this._firebaseServices) : super(SignupInitial());

  static SignupCubit get(context) => BlocProvider.of(context, listen: false);

  bool isPasswordVisible = false;

  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
  }) async {
    emit(SignupLoading());
    try {
      final userCredential = await _firebaseServices.signUpWithEmail(email, password);
      final fcmToken = await _firebaseServices.getFcmToken();
      final user = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        address: address,
        token: fcmToken,
        createdAt: DateTime.now(),
      );
      await _firebaseServices.createUser(user);
      SharedPrefController().isLoggedIn = true;
      emit(SignupSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(SignupError(e.message ?? 'Authentication failed'));
    } catch (e, s) {
      debugPrint("Error: $e");
      debugPrint("StackTrace: $s");
      emit(SignupError('An unexpected error occurred'));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(SignupLoading());
    try {
      final userCredential = await _firebaseServices.signInWithGoogle();
      final userDoc = await _firebaseServices.usersCollection.doc(userCredential.user?.uid).get();

      if (!userDoc.exists) {
        final fcmToken = await _firebaseServices.getFcmToken();
        final user = UserModel(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? 'Google User',
          email: userCredential.user!.email ?? '',
          imageUrl: userCredential.user!.photoURL,
          token: fcmToken,
          createdAt: DateTime.now(),
        );
        await _firebaseServices.createUser(user);
        SharedPrefController().isLoggedIn = true;
        emit(SignupSuccess(user));
      } else {
        final existingUser = UserModel.fromJson(userDoc.data() as Map<String, dynamic>, userDoc.id);
        emit(SignupSuccess(existingUser));
      }
    } catch (e, s) {
      debugPrint("Error: $e");
      debugPrint("StackTrace: $s");
      emit(SignupError('Google sign in failed'));
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(PasswordVisibilityChanged(isPasswordVisible));
  }
}
