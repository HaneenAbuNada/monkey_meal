import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/core/consts/colors/colors.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/consts/validator/payments_validator.dart';
import '../../../manage/payment/payment_cubit.dart';
import '../../../model/payment_model.dart';
import '../../../widgets/custom_button/build_custom_button.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  bool _isLoading = false;

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final FlipCardController _flipCardController = FlipCardController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Payment Method',
          style: TextStyle(color: AppColor.primary, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Credit Card Preview
                FlipCard(
                  controller: _flipCardController,
                  direction: FlipDirection.HORIZONTAL,
                  front: _buildFrontCard(),
                  back: _buildBackCard(),
                ),
                const SizedBox(height: 32),
                // Form Fields
                _buildCardNumberField(),
                const SizedBox(height: 16),
                _buildCardHolderField(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildExpiryDateField()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildCvvField()),
                  ],
                ),
                const SizedBox(height: 32),
                _isLoading
                    ? const CircularProgressIndicator()
                    : customButton(press: _submitForm, title: 'Add Payment Method'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrontCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppColor.orange, Colors.orangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.credit_card, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              _cardNumberController.text.isEmpty ? '•••• •••• •••• ••••' : _cardNumberController.text,
              style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CARD HOLDER', style: TextStyle(color: Colors.white70, fontSize: 10)),
                    Text(
                      _cardHolderController.text.isEmpty ? 'YOUR NAME' : _cardHolderController.text.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('EXPIRES', style: TextStyle(color: Colors.white70, fontSize: 10)),
                    Text(
                      _expiryDateController.text.isEmpty ? '••/••' : _expiryDateController.text,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppColor.orange, Colors.orangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(height: 40, color: Colors.black),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _cvvController.text.isEmpty ? '•••' : _cvvController.text,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'This card is issued by your bank and is subject to terms and conditions',
              style: TextStyle(color: Colors.white70, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardNumberField() {
    return TextFormField(
      controller: _cardNumberController,
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
        if (value.length < 16) {
          return 'Card number must be 16 digits';
        }
        return null;
      },
      onChanged: (value) => setState(() {}),
    );
  }

  // Widget _buildCardHolderField() {
  //   return TextFormField(
  //     controller: _cardHolderController,
  //     decoration: const InputDecoration(
  //       labelText: 'Card Holder Name',
  //       hintText: 'First M.L Name',
  //       prefixIcon: Icon(Icons.person),
  //       border: OutlineInputBorder(),
  //     ),
  //     inputFormatters: [NameInputFormatter(), FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z .]'))],
  //     validator: (value) {
  //       if (value == null || value.isEmpty) {
  //         return 'Please enter card holder name';
  //       }
  //       if (!RegExp(r'^[A-Za-z]+ [A-Za-z]\.[A-Za-z]\.[A-Za-z]+$').hasMatch(value)) {
  //         return 'Format: First M.K Last (e.g. John D.O Smith)';
  //       }
  //       return null;
  //     },
  //     onChanged: (value) => setState(() {}),
  //   );
  // }

  Widget _buildCardHolderField() {
    return TextFormField(
      controller: _cardHolderController,
      decoration: const InputDecoration(
        labelText: 'Card Holder Name',
        hintText: 'e.g. John D.O Smith',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(),
      ),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z .]')), NameInputFormatter()],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter card holder name';
        }
        if (!RegExp(r'^[A-Za-z]+ [A-Za-z]\.[A-Za-z] [A-Za-z]+$').hasMatch(value)) {
          return 'Format: First M.L Last (e.g. John D.O Smith)';
        }
        return null;
      },
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildExpiryDateField() {
    return TextFormField(
      controller: _expiryDateController,
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
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildCvvField() {
    return TextFormField(
      controller: _cvvController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: 'CVV', prefixIcon: Icon(Icons.lock), border: OutlineInputBorder()),
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
      onTap: () => _flipCardController.toggleCard(),
      onChanged: (value) => setState(() {}),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final payment = PaymentModel(
        id: Uuid().v4(),
        cardNumber: _cardNumberController.text.replaceAll(' ', ''),
        cardHolderName: _cardHolderController.text.toUpperCase(),
        expiryDate: _expiryDateController.text,
        cvv: _cvvController.text,
        createdAt: DateTime.now(),
      );

      await BlocProvider.of<PaymentCubit>(context).addPaymentMethod(payment);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment method added successfully')));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
