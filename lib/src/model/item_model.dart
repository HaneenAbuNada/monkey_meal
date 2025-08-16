import 'package:equatable/equatable.dart';

class ItemModel extends Equatable {
  final String itemName;
  final String itemDescription;
  final String itemCover;
  final double itemRating;
  final double itemPrice;

  const ItemModel({
    required this.itemName,
    required this.itemDescription,
    required this.itemCover,
    required this.itemRating,
    required this.itemPrice,
  });

  ItemModel copyWith({
    String? itemName,
    String? itemDescription,
    String? itemCover,
    double? itemRating,
    double? itemPrice,
  }) {
    return ItemModel(
      itemName: itemName ?? this.itemName,
      itemDescription: itemDescription ?? this.itemDescription,
      itemCover: itemCover ?? this.itemCover,
      itemRating: itemRating ?? this.itemRating,
      itemPrice: itemPrice ?? this.itemPrice,
    );
  }

  @override
  List<Object?> get props => [itemName, itemCover, itemDescription, itemPrice, itemRating];

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'itemDescription': itemDescription,
      'itemCover': itemCover,
      'itemRating': itemRating,
      'itemPrice': itemPrice,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      itemName: map['itemName']?.toString() ?? '',
      itemDescription: map['itemDescription']?.toString() ?? '',
      itemCover: map['itemCover']?.toString() ?? '',
      itemRating: (map['itemRating'] as num?)?.toDouble() ?? 0.0,
      itemPrice: (map['itemPrice'] as num?)?.toDouble() ?? 0,
    );
  }
}
