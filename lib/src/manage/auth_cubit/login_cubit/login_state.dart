part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoadingLoginState extends LoginState {}

final class SuccessLoginState extends LoginState {
  final User user;

  const SuccessLoginState(this.user);

  @override
  List<Object> get props => [user];
}

final class FailedLoginState extends LoginState {
  final String error;

  const FailedLoginState(this.error);

  @override
  List<Object> get props => [error];
}

final class LoadingLogoutState extends LoginState {}

final class SuccessLogoutState extends LoginState {
  final User user;

  const SuccessLogoutState(this.user);

  @override
  List<Object> get props => [user];
}

final class FailedLogoutState extends LoginState {
  final String error;

  const FailedLogoutState(this.error);

  @override
  List<Object> get props => [error];
}
