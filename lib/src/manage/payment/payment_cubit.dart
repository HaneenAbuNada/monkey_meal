import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/firebase_helper.dart';
import '../../../core/helper/sqlite_helper.dart';
import '../../model/payment_model.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final FirebaseServices _firebaseServices;
  final SqliteHelper _sqliteHelper = SqliteHelper();

  PaymentCubit({FirebaseServices? firebaseServices})
    : _firebaseServices = firebaseServices ?? FirebaseServices(),
      super(PaymentInitial());

  static PaymentCubit get(context) => BlocProvider.of(context, listen: false);

  Future<void> fetchPaymentMethods() async {
    emit(PaymentLoading());
    try {
      // First try to get from local database
      final localPayments = await _sqliteHelper.getAllPayments();
      if (localPayments.isNotEmpty) {
        emit(PaymentLoaded(localPayments));
      }

      // Then get from Firebase and update local
      final payments = await _firebaseServices.getPaymentMethods();

      // Cache payments in SQLite
      for (final payment in payments) {
        await _sqliteHelper.insertPayment(payment);
      }

      emit(PaymentLoaded(payments));
    } catch (e) {
      // Fallback to local payments if available
      final localPayments = await _sqliteHelper.getAllPayments();
      if (localPayments.isNotEmpty) {
        emit(PaymentLoaded(localPayments));
      } else {
        emit(PaymentError(e.toString()));
      }
    }
  }

  Future<void> addPaymentMethod(PaymentModel payment) async {
    emit(PaymentLoading());
    try {
      // Add to Firebase
      await _firebaseServices.addPaymentMethod(payment);

      // Add to local database
      await _sqliteHelper.insertPayment(payment);

      // Refresh data
      await fetchPaymentMethods();
    } catch (e) {
      // If online fails, store locally with a flag for later sync
      payment = payment.copyWith(isDefault: false);
      await _sqliteHelper.insertPayment(payment);
      emit(PaymentLoaded(await _sqliteHelper.getAllPayments()));
      emit(PaymentError('Added locally. Will sync when online: ${e.toString()}'));
    }
  }

  Future<void> updatePaymentMethod(PaymentModel payment) async {
    try {
      // Update in Firebase
      await _firebaseServices.updatePaymentMethod(payment);

      // Update in local database
      await _sqliteHelper.insertPayment(payment); // Uses replace conflict

      await fetchPaymentMethods();
    } catch (e) {
      // Mark as unsynced if online update fails
      payment = payment.copyWith(isDefault: false);
      await _sqliteHelper.insertPayment(payment);
      emit(PaymentError('Updated locally. Will sync when online: ${e.toString()}'));
    }
  }

  Future<void> deletePaymentMethod(String paymentId) async {
    try {
      // Delete from Firebase
      await _firebaseServices.deletePaymentMethod(paymentId);

      // Delete from local database
      await _sqliteHelper.deletePayment(paymentId);

      await fetchPaymentMethods();
    } catch (e) {
      // Mark as deleted locally if online fails
      final payments = await _sqliteHelper.getAllPayments();
      final payment = payments.firstWhere((p) => p.id == paymentId);
      await _sqliteHelper.insertPayment(payment.copyWith(isDefault: true));
      emit(PaymentError('Marked for deletion. Will sync when online: ${e.toString()}'));
    }
  }

  Future<void> setDefaultPaymentMethod(String paymentId) async {
    try {
      // Set default in Firebase
      await _firebaseServices.setDefaultPaymentMethod(paymentId);

      // Set default in local database
      await _sqliteHelper.setDefaultPayment(paymentId);

      await fetchPaymentMethods();
    } catch (e) {
      // Update locally if online fails
      await _sqliteHelper.setDefaultPayment(paymentId);
      emit(PaymentError('Default set locally. Will sync when online: ${e.toString()}'));
    }
  }

  Future<void> syncLocalPayments() async {
    try {
      final localPayments = await _sqliteHelper.getAllPayments();
      final unSyncedPayments = localPayments.where((p) => p.isDefault == false);
      for (final payment in unSyncedPayments) {
        await _firebaseServices.addPaymentMethod(payment);
        await _sqliteHelper.insertPayment(payment.copyWith(isDefault: true));
      }
      final deletedPayments = localPayments.where((p) => p.isDefault == true);
      for (final payment in deletedPayments) {
        await _firebaseServices.deletePaymentMethod(payment.id);
        await _sqliteHelper.deletePayment(payment.id);
      }
      await fetchPaymentMethods();
    } catch (e) {
      emit(PaymentError('Sync failed: ${e.toString()}'));
    }
  }
}
