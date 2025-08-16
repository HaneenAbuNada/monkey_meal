import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/consts/functions/animations.dart';
import '../../manage/payment/payment_cubit.dart';
import '../../model/payment_model.dart';
import '../../screens/app/payments/payment_screen.dart';

class SelectPaymentMethod extends StatefulWidget {
  const SelectPaymentMethod({super.key});

  @override
  State<SelectPaymentMethod> createState() => _SelectPaymentMethodState();
}

class _SelectPaymentMethodState extends State<SelectPaymentMethod> {
  String? selectedPaymentId;
  PaymentModel? defaultPayment;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentCubit()..fetchPaymentMethods(),
      child: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          if (state is PaymentLoaded) {
            defaultPayment = state.paymentMethods.firstWhere(
              (payment) => payment.isDefault,
              orElse:
                  () => PaymentModel(
                    id: 'cash',
                    cardNumber: '',
                    cardHolderName: 'Cash on delivery',
                    expiryDate: '',
                    cvv: '',
                    isDefault: false,
                    createdAt: DateTime.now(),
                  ),
            );

            selectedPaymentId ??= defaultPayment!.id;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Payment method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    InkWell(
                      onTap: () => NavAndAnimationsFunctions.navToWithRTLAnimation(context, PaymentScreen()),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.orange),
                          SizedBox(width: 4),
                          Text('Add Card', style: TextStyle(color: Colors.orange)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Cash on delivery
                buildPaymentMethodItem(
                  title: 'Cash on delivery',
                  isSelected: selectedPaymentId == 'cash',
                  onTap: () => setState(() => selectedPaymentId = 'cash'),
                ),
                SizedBox(height: 10),

                // Default payment card (if exists)
                if (state is PaymentLoaded && defaultPayment!.id != 'cash')
                  Column(
                    children: [
                      buildPaymentMethodItem(
                        title: defaultPayment!.cardHolderName,
                        subtitle: defaultPayment!.maskedCardNumber,
                        imagePath: "assets/images/visa_image.png",
                        isSelected: selectedPaymentId == defaultPayment!.id,
                        onTap: () => setState(() => selectedPaymentId = defaultPayment!.id),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),

                // PayPal
                buildPaymentMethodItem(
                  title: 'PayPal',
                  subtitle: 'johndoe@email.com',
                  imagePath: 'assets/images/paypal_image.png',
                  isSelected: selectedPaymentId == 'paypal',
                  onTap: () => setState(() => selectedPaymentId = 'paypal'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildPaymentMethodItem({
    required String title,
    String? subtitle,
    String? imagePath,
    required bool isSelected,
    required VoidCallback onTap,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isSelected ? Colors.orange : Colors.transparent, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 0.2), spreadRadius: 1, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          if (imagePath != null) ...[Image.asset(imagePath, height: 24, width: 24), SizedBox(width: 16)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                if (subtitle != null) ...[
                  SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ],
            ),
          ),
          Radio(value: true, groupValue: isSelected, onChanged: (_) => onTap(), activeColor: Colors.orange),
        ],
      ),
    ),
  );
}

// class SelectPaymentMethod extends StatelessWidget {
//   const SelectPaymentMethod({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Payment method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//               InkWell(
//                 onTap: () => NavAndAnimationsFunctions.navToWithRTLAnimation(context, PaymentScreen()),
//                 child: Row(
//                   children: [
//                     Icon(Icons.add, color: Colors.orange),
//                     SizedBox(width: 4),
//                     Text('Add Card', style: TextStyle(color: Colors.orange)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           buildPaymentMethodItem(title: 'Cash on delivery'),
//           SizedBox(height: 10),
//
//           /// Implement a used payment here (isDefault = true) !!!
//           buildPaymentMethodItem(
//             title: 'VISA',
//             subtitle: '**** **** **** 2187',
//             imagePath: 'assets/images/visa_image.png',
//           ),
//           /// Implement a used payment here (isDefault = true) !!!
//
//           SizedBox(height: 10),
//           buildPaymentMethodItem(
//             title: 'paypal',
//             subtitle: 'johndoe@email.com',
//             imagePath: 'assets/images/paypal_image.png',
//           ),
//         ],
//       ),
//     );
//   }
// }
