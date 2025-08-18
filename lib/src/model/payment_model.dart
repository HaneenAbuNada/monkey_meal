import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PaymentModel extends Equatable {
  final String id;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;
  final bool isDefault;
  final DateTime createdAt;

  const PaymentModel({
    required this.id,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
    this.isDefault = false,
    required this.createdAt,
  });

  factory PaymentModel.fromFirestore(String id, Map<String, dynamic> data) {
    DateTime parseCreatedAt(dynamic createdAt) {
      if (createdAt is Timestamp) {
        return createdAt.toDate();
      } else if (createdAt is int) {
        return DateTime.fromMillisecondsSinceEpoch(createdAt);
      }
      return DateTime.now();
    }

    return PaymentModel(
      id: id,
      cardNumber: data['cardNumber']?.toString() ?? '',
      cardHolderName: data['cardHolderName']?.toString() ?? '',
      expiryDate: data['expiryDate']?.toString() ?? '',
      cvv: data['cvv']?.toString() ?? '',
      isDefault: data['isDefault'] ?? false,
      createdAt: parseCreatedAt(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'isDefault': isDefault,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  String get maskedCardNumber {
    if (cardNumber.length < 4) return cardNumber;
    return '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
  }

  @override
  List<Object?> get props => [id, cardNumber, cardHolderName, expiryDate, cvv, isDefault, createdAt];

  PaymentModel copyWith({
    String? id,
    String? cardNumber,
    String? cardHolderName,
    String? expiryDate,
    String? cvv,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
