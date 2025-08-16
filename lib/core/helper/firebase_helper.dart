import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:monkey_meal/src/model/offer_item_model.dart';

import '../../src/model/item_model.dart';
import '../../src/model/order_model.dart';
import '../../src/model/payment_model.dart';
import '../../src/model/user_model.dart';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  User? get currentUser => _auth.currentUser;

  String? get currentUserId => _auth.currentUser?.uid;

  // Collections
  CollectionReference get usersCollection => _firestore.collection('users');

  CollectionReference get foodsCollection => _firestore.collection('foods');

  CollectionReference get offersCollection => _firestore.collection('offers');

  /// Initialize FCM token
  Future<String?> getFcmToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  /// Authentication
  Future<User> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential> signUpWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async => await _auth.signOut();

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Google sign in error: $e');
      rethrow;
    }
  }

  /// User Management
  Future<void> createUser(UserModel user) async {
    try {
      await usersCollection.doc(user.id).set(user.toJson());
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  Future<UserModel> getUser(String userId) async {
    try {
      final doc = await usersCollection.doc(userId).get();
      return UserModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      print('Error getting user: $e');
      rethrow;
    }
  }

  Future<void> updateUserData({
    required String userId,
    required String name,
    required String email,
    String? phone,
    String? address,
    String? imageUrl,
  }) async {
    try {
      await usersCollection.doc(userId).update({
        'name': name,
        'email': email,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
        if (imageUrl != null) 'imageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating user: $e');
      throw Exception('Failed to update user data');
    }
  }

  Future<List<ItemModel>> getFoods() async {
    final snapshot = await foodsCollection.get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return ItemModel.fromMap({
        ...data,
        'itemName': data['itemName'] ?? doc.id,
        'itemDescription': data['itemDescription'] ?? '',
        'itemCover': data['itemCover'] ?? '',
        'itemRating': (data['itemRating'] ?? 0.0).toDouble(),
        'itemPrice': data['itemPrice'] ?? 0,
      });
    }).toList();
  }

  Future<List<OfferItemModel>> getOffers() async {
    try {
      final snapshot = await offersCollection.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OfferItemModel.fromMap({
          'offerCover': data['offerCover'] ?? '',
          'offerName': data['offerName'] ?? doc.id,
          'offerDescription': data['offerDescription'] ?? '',
          'offerCategory': data['offerCategory'] ?? '',
          'offerSubCategory': data['offerSubCategory'] ?? '',
          'offerRatingCount': (data['offerRatingCount'] ?? 0.0).toDouble(),
          'offerRatingNumbers': (data['offerRatingNumbers'] ?? 0.0).toDouble(),
          'offerOldPrice': (data['offerOldPrice'] ?? 0.0).toDouble(),
          'offerNewPrice': (data['offerNewPrice'] ?? 0.0).toDouble(),
        });
      }).toList();
    } catch (e, s) {
      debugPrint('Error fetching offers: $e');
      debugPrint('Error fetching offers: $s');
      throw Exception('Failed to load offers');
    }
  }

  Future<void> addToFavorites(String userId, ItemModel item) async {
    try {
      await usersCollection.doc(userId).collection('favorites').doc(item.itemName).set(item.toJson());
    } catch (e) {
      print('Error adding to favorites: $e');
      rethrow;
    }
  }

  Future<void> removeFromFavorites(String userId, String itemName) async {
    try {
      await usersCollection.doc(userId).collection('favorites').doc(itemName).delete();
    } catch (e) {
      print('Error removing from favorites: $e');
      rethrow;
    }
  }

  Future<bool> isFavorite(String userId, String itemName) async {
    try {
      final doc = await usersCollection.doc(userId).collection('favorites').doc(itemName).get();
      return doc.exists;
    } catch (e) {
      print('Error checking favorite: $e');
      rethrow;
    }
  }

  Future<void> addToOrder(String userId, ItemModel item, int quantity) async {
    try {
      final orderData = {
        ...item.toJson(),
        'quantity': quantity,
        'orderedAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      };

      await usersCollection.doc(userId).collection('orders').doc().set(orderData);
    } catch (e) {
      print('Error adding to order: $e');
      rethrow;
    }
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      final snapshot =
          await usersCollection.doc(userId).collection('orders').orderBy('orderedAt', descending: true).get();

      return snapshot.docs.map((doc) {
        return OrderModel.fromFirestore(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print('Error getting user orders: $e');
      rethrow;
    }
  }

  Future<void> updateOrderStatus(String userId, String orderId, String status) async {
    try {
      await usersCollection.doc(userId).collection('orders').doc(orderId).update({'status': status});
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }

  Future<void> addPaymentMethod(PaymentModel payment) async {
    try {
      if (currentUserId == null) throw Exception('User not authenticated');

      await usersCollection.doc(currentUserId).collection('payment_methods').doc(payment.id).set(payment.toMap());
    } catch (e) {
      print('Error adding payment method: $e');
      rethrow;
    }
  }

  Future<List<PaymentModel>> getPaymentMethods() async {
    try {
      if (currentUserId == null) throw Exception('User not authenticated');

      final snapshot =
          await usersCollection
              .doc(currentUserId)
              .collection('payment_methods')
              .orderBy('createdAt', descending: true)
              .get();

      return snapshot.docs.map((doc) {
        return PaymentModel.fromFirestore(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print('Error getting payment methods: $e');
      rethrow;
    }
  }

  Future<void> updatePaymentMethod(PaymentModel payment) async {
    try {
      if (currentUserId == null) throw Exception('User not authenticated');

      await usersCollection.doc(currentUserId).collection('payment_methods').doc(payment.id).update(payment.toMap());
    } catch (e) {
      print('Error updating payment method: $e');
      rethrow;
    }
  }

  Future<void> deletePaymentMethod(String paymentId) async {
    try {
      if (currentUserId == null) throw Exception('User not authenticated');

      await usersCollection.doc(currentUserId).collection('payment_methods').doc(paymentId).delete();
    } catch (e) {
      print('Error deleting payment method: $e');
      rethrow;
    }
  }

  Future<void> setDefaultPaymentMethod(String paymentId) async {
    try {
      if (currentUserId == null) throw Exception('User not authenticated');
      final batch = _firestore.batch();
      final paymentMethods = await usersCollection.doc(currentUserId).collection('payment_methods').get();

      for (final doc in paymentMethods.docs) {
        batch.update(doc.reference, {'isDefault': false});
      }
      batch.update(usersCollection.doc(currentUserId).collection('payment_methods').doc(paymentId), {
        'isDefault': true,
      });

      await batch.commit();
    } catch (e) {
      print('Error setting default payment method: $e');
      rethrow;
    }
  }

  FirebaseAuthException _handleAuthException(FirebaseAuthException e) {
    print('Auth error (${e.code}): ${e.message}');
    return e;
  }
}
