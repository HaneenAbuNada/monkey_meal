part of 'edit_user_data_cubit.dart';

abstract class EditUserDataState {}

class EditUserInitial extends EditUserDataState {}

class LoadingGetUserDataFromFirebaseState extends EditUserDataState {}

class SuccessGetUserDataFromFirebaseState extends EditUserDataState {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? image;

  SuccessGetUserDataFromFirebaseState({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.image,
  });

  SuccessGetUserDataFromFirebaseState copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? image,
  }) {
    return SuccessGetUserDataFromFirebaseState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      image: image ?? this.image,
    );
  }
}

class FailedGetUserDataFromFirebaseState extends EditUserDataState {
  final String message;

  FailedGetUserDataFromFirebaseState(this.message);
}

class EditUserLoading extends EditUserDataState {}

class EditUserSuccess extends EditUserDataState {}

class EditUserError extends EditUserDataState {
  final String message;

  EditUserError(this.message);
}

class EditUserImagePicked extends EditUserDataState {
  final File image;

  EditUserImagePicked(this.image);
}
