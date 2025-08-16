part of 'signup_cubit.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final UserModel user;

  const SignupSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class SignupError extends SignupState {
  final String message;

  const SignupError(this.message);

  @override
  List<Object> get props => [message];
}

class PasswordVisibilityChanged extends SignupState {
  final bool isVisible;

  const PasswordVisibilityChanged(this.isVisible);

  @override
  List<Object> get props => [isVisible];
}