part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final List<PaymentModel> paymentMethods;

  const PaymentLoaded(this.paymentMethods);

  @override
  List<Object> get props => [paymentMethods];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object> get props => [message];
}