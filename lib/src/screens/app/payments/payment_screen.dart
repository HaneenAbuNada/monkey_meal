import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/core/consts/colors/colors.dart';
import 'package:monkey_meal/src/screens/app/payments/add_payment_screen.dart';
import 'package:monkey_meal/src/widgets/custom_bottom_sheet/edit_payment_bottom_sheet.dart';

import '../../../../core/consts/functions/animations.dart';
import '../../../manage/payment/payment_cubit.dart';
import '../../../model/payment_model.dart';
import '../../../widgets/custom_button/build_custom_button.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Payment Methods",
          style: TextStyle(color: AppColor.primary, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocProvider(
        create: (context) => PaymentCubit()..fetchPaymentMethods(),
        child: BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, state) {
            if (state is PaymentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PaymentError) {
              return Center(child: Text(state.message));
            } else if (state is PaymentLoaded) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 5, left: 30, right: 30),
                    child: Column(
                      spacing: 15,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Customize your payment method",
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.primary, fontSize: 16),
                        ),
                        SizedBox(height: 2, child: Divider(color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                  Expanded(child: _buildPaymentList(context, state.paymentMethods)),
                ],
              );
            }
            return const Center(child: Text('No payment methods found'));
          },
        ),
      ),
    );
  }

  Widget _buildPaymentList(BuildContext context, List<PaymentModel> payments) {
    if (payments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.credit_card_off, size: 50, color: Colors.grey),
            const SizedBox(height: 16),
            Text('No payment methods added yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: customButton(
                title: "Add Payment Method",
                press: () => NavAndAnimationsFunctions.navToWithRTLAnimation(context, const AddPaymentScreen()),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 10),
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: payments.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
                    builder:
                        (_) => EditPaymentBottomSheet(
                          payment: payments[index],
                          onSaved: () => PaymentCubit.get(context).fetchPaymentMethods(),
                        ),
                  );
                },
                child: _buildPaymentCard(context, payments[index]),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
          child: customButton(
            press: () async {
              final result = await NavAndAnimationsFunctions.navToWithRTLAnimation(context, const AddPaymentScreen());
              if (result == true && context.mounted) {
                PaymentCubit.get(context).fetchPaymentMethods();
              }
            },
            title: "+ Add another Credit/Debit Card",
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentCard(BuildContext context, PaymentModel payment) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    color: AppColor.placeholderBg,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Cash/Card on delivery",
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.primary, fontSize: 16),
              ),
              payment.isDefault
                  ? Icon(Icons.check_circle, color: AppColor.orange, size: 20)
                  : IconButton(
                    icon: const Icon(Icons.check, size: 16),
                    onPressed: () => PaymentCubit.get(context).setDefaultPaymentMethod(payment.id),
                  ),
            ],
          ),
          SizedBox(height: 2, child: Divider(color: Colors.grey.shade500)),
          Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Row(
                    spacing: 15,
                    children: [
                      Image.asset('assets/images/visa_image.png', height: 60, width: 60),
                      Text(payment.maskedCardNumber, style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: customOutlinedButton(
                  press: () => _showDeleteDialog(context, payment.id),
                  title: "Delete Card",
                  fontSize: 11,
                  height: 30,
                ),
              ),
            ],
          ),
          SizedBox(height: 2, child: Divider(color: Colors.grey.shade500)),
          SizedBox(height: 20),
          Text(
            "Other methods",
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.placeholder, fontSize: 16),
          ),
        ],
      ),
    ),
  );

  void _showDeleteDialog(BuildContext context, String paymentId) => showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Delete Payment Method'),
          content: const Text('Are you sure you want to delete this payment method?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed:
                  () => PaymentCubit.get(context).deletePaymentMethod(paymentId).then((value) {
                    Navigator.pop(context, true);
                    PaymentCubit().fetchPaymentMethods();
                  }),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
  );
}
