import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? password;
  final String? phone;
  final String? address;
  final String? token;
  final String? imageUrl;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.phone,
    this.address,
    this.token,
    this.imageUrl,
    required this.createdAt,
  });

  factory UserModel.empty() => UserModel(id: '', name: '', email: '', createdAt: DateTime.now());

  factory UserModel.fromJson(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'],
      address: data['address'],
      token: data['token'],
      imageUrl: data['imageUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'token': token,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? phone,
    String? address,
    String? token,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      token: token ?? this.token,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, email, password, phone, address, token, imageUrl, createdAt];
}
