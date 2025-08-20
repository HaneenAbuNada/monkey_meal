import 'package:flutter/material.dart';
import 'package:monkey_meal/src/widgets/checkout_components/delivery_address_widget.dart';
import 'package:monkey_meal/src/widgets/checkout_components/final_pays_details_widget.dart';
import 'package:monkey_meal/src/widgets/checkout_components/select_payment_method_widget.dart';
import 'package:monkey_meal/src/widgets/custom_button/build_custom_button.dart';

import '../../../../core/consts/colors/colors.dart';
import '../../../../core/helper/firebase_helper.dart';
import '../../../widgets/custom_bottom_sheet/build_success_bottom_sheet.dart';

class CheckoutScreen extends StatelessWidget {
  final String currentAddress, subTotal, total;

  const CheckoutScreen({super.key, required this.currentAddress, required this.subTotal, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Checkout', style: TextStyle(color: AppColor.primary, fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            deliveryAddressWidget(context, currentAddress),
            SizedBox(child: Divider(color: Colors.grey.shade300, thickness: 16)),
            SelectPaymentMethod(),
            SizedBox(child: Divider(color: Colors.grey.shade300, thickness: 16)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildFinalPayDetailsWidget(subTotal: subTotal, total: total),
            ),
            /*
            showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                  ),
                  builder: (_) => OrderSuccessBottomSheet(),
                );
                */
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: customButton(
                title: 'Send order',
                press: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(child: CircularProgressIndicator()),
                  );
                  try {
                    final firebaseServices = FirebaseServices();
                    await firebaseServices.deleteUserOrders(firebaseServices.currentUserId!);
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                      ),
                      builder: (_) => OrderSuccessBottomSheet(),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
