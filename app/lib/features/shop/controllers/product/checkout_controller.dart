import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../personalization/controllers/settings_controller.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../models/payment_method_model.dart';
import '../../screens/checkout/widgets/payment_tile.dart';
import '../coupon_controller.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  RxBool isUsingPoints = false.obs;
  RxBool isCouponToggled = false.obs;

  //final couponController = CouponController.instance;
  final couponController = Get.put(CouponController());
  final settingsController = SettingsController.instance;
  final userController = Get.put(UserController());

  RxDouble couponDiscountAmount = 0.0.obs;
  RxDouble pointsDiscountAmount = 0.0.obs;
  final Rx<PaymentMethodModel> selectedPaymentMethod =
      PaymentMethodModel(name: TTexts.cashOnDelivery.tr, image: TImages.cod, paymentMethod: PaymentMethods.cash).obs;

  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder:
          (_) => SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(TSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TSectionHeading(title: TTexts.selectPaymentMethod.tr, showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  ...PaymentMethods.values.map((paymentMethod) {
                    switch (paymentMethod) {
                      case PaymentMethods.cash:
                        return TPaymentTile(
                          paymentMethodModel: PaymentMethodModel(
                            image: TImages.cod,
                            name: TTexts.cashOnDelivery.tr,
                            paymentMethod: PaymentMethods.cash,
                          ),
                        );
                      case PaymentMethods.card:
                        return TPaymentTile(
                          paymentMethodModel: PaymentMethodModel(
                            image: TImages.masterCard,
                            name: TTexts.visaMasterCard.tr,
                            paymentMethod: PaymentMethods.card,
                          ),
                        );
                      case PaymentMethods.paypal:
                        return TPaymentTile(
                          paymentMethodModel: PaymentMethodModel(
                            name: TTexts.paypal.tr,
                            image: TImages.paypal,
                            paymentMethod: PaymentMethods.paypal,
                          ),
                        );
                    }
                  }),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
          ),
    );
  }

  bool isShippingFree(double subTotal) {
    // Check if a free shipping threshold is set and if the subtotal exceeds it
    final freeShippingThreshold = settingsController.settings.value.freeShippingThreshold;
    return freeShippingThreshold != null && freeShippingThreshold > 0.0 && subTotal >= freeShippingThreshold;
  }

  double getShippingCost(double subTotal) {
    // Return 0 if shipping is free, otherwise use the specified shipping cost
    return isShippingFree(subTotal) ? 0.0 : settingsController.settings.value.shippingCost;
  }

  double getTaxAmount(double subTotal) {
    // Calculate total discount
    double totalDiscount = calculateTotalDiscount(subTotal);

    // Adjust the subtotal by subtracting the discount, ensuring it doesn't go below zero
    double discountAdjustedSubTotal = (subTotal - totalDiscount).clamp(0.0, double.infinity);

    final taxAmount = discountAdjustedSubTotal * settingsController.settings.value.taxRate;

    // Return the tax amount based on the adjusted subtotal and tax rate
    return taxAmount;
  }

  double calculateTotalDiscount(double subTotal) {
    // Calculate the discount based on points if they are being used
    final pointsDiscount =
        isUsingPoints.value
            ? userController.user.value.points.toDouble() / settingsController.settings.value.pointsToDollarConversion
            : 0.0;

    if (pointsDiscount > subTotal) {
      pointsDiscountAmount.value = subTotal;
    } else {
      pointsDiscountAmount.value = pointsDiscount;
    }

    // Calculate the discount based on the coupon if it's being used
    final couponDiscountAmount =
        isCouponToggled.value
            ? (couponController.coupon.value.discountType.name == DiscountType.percentage.name
                ? ((couponController.coupon.value.discountValue * subTotal) / 100)
                : couponController.coupon.value.discountValue)
            : 0.0;
    // couponDiscountAmount.value = isCouponToggled.value ? couponController.coupon.value.discountValue : 0.0;

    // Sum up the coupon discount and points discount
    return couponDiscountAmount + pointsDiscount;
  }

  double calculateGrandTotal(double subTotal) {
    // Step 1: Calculate total discount
    double totalDiscount = calculateTotalDiscount(subTotal);

    // Step 2: Adjust subtotal by subtracting the discount, clamping to avoid negative values
    double discountAdjustedSubTotal = (subTotal - totalDiscount).clamp(0.0, double.infinity);

    // Step 3: Check if tax and shipping are enabled
    double taxAmount = 0.0;
    double shippingCost = 0.0;

    if (settingsController.settings.value.isTaxShippingEnabled) {
      // Step 3a: Calculate tax based on the subtotal
      taxAmount = getTaxAmount(subTotal);

      // Step 3b: Get the shipping cost based on the adjusted subtotal
      shippingCost = getShippingCost(discountAdjustedSubTotal);
    }

    // Step 4: Calculate the grand total by summing the adjusted subtotal, tax, and shipping
    return discountAdjustedSubTotal + taxAmount + shippingCost;
  }
}
