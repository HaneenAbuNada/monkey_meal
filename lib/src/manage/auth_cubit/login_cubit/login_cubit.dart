import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/core/shared_preferenced/shared_preferenced.dart';
import 'package:monkey_meal/src/model/user_model.dart';
import 'package:monkey_meal/src/screens/app/layout.dart';
import 'package:monkey_meal/src/screens/auth/landing/landing_screen.dart';

import '../../../../core/consts/functions/animations.dart';
import '../../../widgets/custom_snackbar/build_custom_snackbar_widget.dart';
import '../../../../core/helper/sqlite_helper.dart';

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
      final db = await SqliteHelper().database;

      final result = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [
          emailController.text.trim(),
          passwordController.text.trim(),
        ],
      );

      UserModel? dbUser;
      if (result.isNotEmpty) {
        dbUser = UserModel.fromJson(result.first, result.first['id'].toString());
      }

      if (dbUser != null) {
        SharedPrefController().isLoggedIn = true;
        emit(SuccessLoginState(dbUser));
        NavAndAnimationsFunctions.navAndFinish(context, const Layout());
      } else {
        showErrorSnackBar("Email or password is incorrect!", 3, context);
        emit(FailedLoginState("Email or password is incorrect!"));
      }
    } catch (e) {
      showErrorSnackBar("Login Failed!! ${e.toString()}", 3, context);
      emit(FailedLoginState("Login Failed!! $e"));
    }
  }

  Future<void> logout(context) async {
    try {
      SharedPrefController().isLoggedIn = false;
      await SharedPrefController().clear();

      NavAndAnimationsFunctions.navAndFinish(context, const LandingScreen());
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }
}
