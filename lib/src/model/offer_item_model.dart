class OfferItemModel {
  final String offerName;
  final String offerDescription;
  final String offerCover;
  final String offerCategory;
  final String offerSubCategory;
  final double offerRatingCount;
  final double offerRatingNumbers;
  final double offerOldPrice;
  final double offerNewPrice;

  const OfferItemModel({
    required this.offerCover,
    required this.offerName,
    required this.offerDescription,
    required this.offerCategory,
    required this.offerSubCategory,
    required this.offerRatingCount,
    required this.offerRatingNumbers,
    required this.offerOldPrice,
    required this.offerNewPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'offerCover': offerCover,
      'offerName': offerName,
      'offerDescription': offerDescription,
      'offerCategory': offerCategory,
      'offerSubCategory': offerSubCategory,
      'offerRatingCount': offerRatingCount,
      'offerRatingNumbers': offerRatingNumbers,
      'offerOldPrice': offerOldPrice,
      'offerNewPrice': offerNewPrice,
    };
  }

  factory OfferItemModel.fromMap(Map<String, dynamic> map) {
    return OfferItemModel(
      offerCover: map['offerCover'] as String,
      offerName: map['offerName'] as String,
      offerDescription: map['offerDescription'] as String,
      offerCategory: map['offerCategory'] as String,
      offerSubCategory: map['offerSubCategory'] as String,
      offerRatingCount: map['offerRatingCount'] as double,
      offerRatingNumbers: map['offerRatingNumbers'] as double,
      offerOldPrice: map['offerOldPrice'] as double,
      offerNewPrice: map['offerNewPrice'] as double,
    );
  }

  OfferItemModel copyWith({
    String? offerCover,
    String? offerName,
    String? offerDescription,
    String? offerCategory,
    String? offerSubCategory,
    double? offerRatingCount,
    double? offerRatingNumbers,
    double? offerOldPrice,
    double? offerNewPrice,
  }) {
    return OfferItemModel(
      offerCover: offerCover ?? this.offerCover,
      offerName: offerName ?? this.offerName,
      offerDescription: offerDescription ?? this.offerDescription,
      offerCategory: offerCategory ?? this.offerCategory,
      offerSubCategory: offerSubCategory ?? this.offerSubCategory,
      offerRatingCount: offerRatingCount ?? this.offerRatingCount,
      offerRatingNumbers: offerRatingNumbers ?? this.offerRatingNumbers,
      offerOldPrice: offerOldPrice ?? this.offerOldPrice,
      offerNewPrice: offerNewPrice ?? this.offerNewPrice,
    );
  }
}

// static List<OfferItemModel> offerItems = [
//   OfferItemModel(
//     imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587',
//     title: 'Café de Noires',
//     rating: 4.9,
//     ratingsCount: 124,
//     categories: 'Cafe • Western Food',
//   ),
//   OfferItemModel(
//     imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587',
//     title: 'Isso',
//     rating: 4.5,
//     ratingsCount: 98,
//     categories: 'Seafood • Fusion',
//   ),
//   OfferItemModel(
//     imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587',
//     title: 'Green Bowl',
//     rating: 4.7,
//     ratingsCount: 205,
//     categories: 'Healthy • Vegan',
//   ),
//   OfferItemModel(
//     imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587',
//     title: 'Pizza Place',
//     rating: 4.2,
//     ratingsCount: 310,
//     categories: 'Italian • Pizza',
//   ),
//   OfferItemModel(
//     imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587',
//     title: 'Sushi Time',
//     rating: 4.8,
//     ratingsCount: 150,
//     categories: 'Japanese • Sushi',
//   ),
// ];
