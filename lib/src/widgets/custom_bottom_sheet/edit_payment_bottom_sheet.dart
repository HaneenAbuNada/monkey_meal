import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monkey_meal/src/widgets/custom_button/build_custom_button.dart';

import '../../../core/consts/validator/payments_validator.dart';
import '../../manage/payment/payment_cubit.dart';
import '../../model/payment_model.dart';

class EditPaymentBottomSheet extends StatefulWidget {
  final PaymentModel? payment;
  final void Function()? onSaved;

  const EditPaymentBottomSheet({super.key, this.payment, this.onSaved});

  @override
  State<EditPaymentBottomSheet> createState() => _EditPaymentBottomSheetState();
}

class _EditPaymentBottomSheetState extends State<EditPaymentBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController cardNumberController;
  late TextEditingController expiryDateController;
  late TextEditingController cvvController;
  late TextEditingController cardHolderController;

  @override
  void initState() {
    super.initState();
    cardNumberController = TextEditingController(text: widget.payment?.cardNumber ?? '');
    expiryDateController = TextEditingController(text: widget.payment?.expiryDate ?? '');
    cvvController = TextEditingController(text: widget.payment?.cvv ?? '');
    cardHolderController = TextEditingController(text: widget.payment?.cardHolderName ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.payment == null ? "Add Credit/Debit Card" : "Edit Credit/Debit Card",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Card Number
              TextFormField(
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  prefixIcon: Icon(Icons.credit_card),
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CardNumberFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  if (value.replaceAll(' ', '').length < 16) {
                    return 'Card number must be 16 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Card Holder Name (Full Name)
              TextFormField(
                controller: cardHolderController,
                decoration: const InputDecoration(
                  labelText: 'Card Holder Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card holder name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Expiry Date
              TextFormField(
                controller: expiryDateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Expiry Date (MM/YY)',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  CardExpiryFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expiry date';
                  }
                  if (value.length < 5) {
                    return 'Please enter full date (MM/YY)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // CVV
              TextFormField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter CVV';
                  }
                  if (value.length < 3) {
                    return 'CVV must be 3 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Save Button
              customButton(
                title: widget.payment == null ? "+ Add Card" : "Save Changes",
                press: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final payment = PaymentModel(
                    id: widget.payment?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                    cardNumber: cardNumberController.text.replaceAll(' ', ''),
                    cardHolderName: cardHolderController.text,
                    expiryDate: expiryDateController.text,
                    cvv: cvvController.text,
                    createdAt: widget.payment?.createdAt ?? DateTime.now(),
                  );

                  if (widget.payment == null) {
                    await PaymentCubit.get(context).addPaymentMethod(payment);
                  } else {
                    await PaymentCubit.get(context).updatePaymentMethod(payment);
                  }

                  Navigator.pop(context);
                  widget.onSaved?.call();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
