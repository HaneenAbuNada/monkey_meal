import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/src/screens/app/layout.dart';

import '../../../../core/consts/functions/animations.dart';
import '../../../../core/helper/firebase_helper.dart';
import '../../../../core/shared_preferenced/shared_preferenced.dart';
import '../../../screens/auth/landing/landing_screen.dart';
import '../../../widgets/custom_snackbar/build_custom_snackbar_widget.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context, listen: false);

  Future<void> login(
    context, {
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    emit(LoadingLoginState());
    try {
      final user = await FirebaseServices().signInWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      SharedPrefController().isLoggedIn = true;
      emit(SuccessLoginState(user));
      NavAndAnimationsFunctions.navAndFinish(context, const Layout());
    } on FirebaseAuthException catch (firebaseMessage) {
      switch (firebaseMessage.code) {
        case 'user-not-found':
          showErrorSnackBar("This email not found in the server! Try again.", 3, context);
          emit(FailedLoginState("This email not found in the server! Try again."));
          break;
        case 'wrong-password':
          showErrorSnackBar("Wrong password, Enter it again.", 3, context);
          emit(FailedLoginState("Wrong password, Enter it again."));
          break;
        case 'invalid-email':
          showErrorSnackBar("Wrong email, Enter it again.", 3, context);
          emit(FailedLoginState("Wrong email, Enter it again."));
          break;
        case 'user-disabled':
          showErrorSnackBar("This email disabled, register a new user.", 3, context);
          emit(FailedLoginState("This email disabled, register a new user."));
          break;
        case 'operation-not-allowed':
          showErrorSnackBar("The login operation crashing right now.", 3, context);
          emit(FailedLoginState("The login operation crashing right now."));
          break;
        case 'too-many-requests':
          showErrorSnackBar("Too many requests", 3, context);
          emit(FailedLoginState("Too many requests"));
          break;
        default:
          print(">>>>>>>>>>>Error: ${firebaseMessage.message}");
          print(">>>>>>>>>>>StackTrace: ${firebaseMessage.stackTrace}");
          showErrorSnackBar("An unknown error occurred", 3, context);
          emit(FailedLoginState('An unknown error occurred'));
          break;
      }
    } catch (e) {
      showErrorSnackBar("Login Failed!! ${e.toString()}", 3, context);
      emit(FailedLoginState("Login Failed!!$e"));
    }
  }

  Future<void> logout(context) async {
    try {
      await FirebaseServices().signOut();
      SharedPrefController().isLoggedIn = false;
      await SharedPrefController().clear();
      NavAndAnimationsFunctions.navAndFinish(context, const LandingScreen());
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }
}
