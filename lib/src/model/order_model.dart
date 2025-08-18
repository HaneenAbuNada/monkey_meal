import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final String id;
  final String itemName;
  final String itemDescription;
  final String itemCover;
  final double itemRating;
  final double itemPrice;
  final int quantity;
  final DateTime orderedAt;
  final String status;

  const OrderModel({
    required this.id,
    required this.itemName,
    required this.itemDescription,
    required this.itemCover,
    required this.itemRating,
    required this.itemPrice,
    required this.quantity,
    required this.orderedAt,
    required this.status,
  });

  factory OrderModel.fromFirestore(String id, Map<String, dynamic> data) {
    return OrderModel(
      id: id,
      itemName: data['itemName']?.toString() ?? '',
      itemDescription: data['itemDescription']?.toString() ?? '',
      itemCover: data['itemCover']?.toString() ?? '',
      itemRating: (data['itemRating'] as num?)?.toDouble() ?? 0.0,
      itemPrice: (data['itemPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: (data['quantity'] as int?) ?? 1,
      orderedAt: data['orderedAt'] is Timestamp
          ? (data['orderedAt'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(data['orderedAt'] as int? ?? 0),
      status: data['status']?.toString() ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'itemDescription': itemDescription,
      'itemCover': itemCover,
      'itemRating': itemRating,
      'itemPrice': itemPrice,
      'quantity': quantity,
      'orderedAt': orderedAt.millisecondsSinceEpoch,
      'status': status,
    };
  }

  double get totalPrice => itemPrice * quantity;

  @override
  List<Object?> get props => [
    id,
    itemName,
    itemDescription,
    itemCover,
    itemRating,
    itemPrice,
    quantity,
    orderedAt,
    status,
  ];

  OrderModel copyWith({
    String? id,
    String? itemName,
    String? itemDescription,
    String? itemCover,
    double? itemRating,
    double? itemPrice,
    int? quantity,
    DateTime? orderedAt,
    String? status,
  }) {
    return OrderModel(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      itemDescription: itemDescription ?? this.itemDescription,
      itemCover: itemCover ?? this.itemCover,
      itemRating: itemRating ?? this.itemRating,
      itemPrice: itemPrice ?? this.itemPrice,
      quantity: quantity ?? this.quantity,
      orderedAt: orderedAt ?? this.orderedAt,
      status: status ?? this.status,
    );
  }
}
