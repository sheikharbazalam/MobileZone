import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../personalization/controllers/settings_controller.dart';
import '../../controllers/product/cart_controller.dart';
import '../checkout/checkout.dart';
import 'widgets/cart_items.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    final cartItems = controller.cartItems;
    final settingsController = SettingsController.instance;
    return Scaffold(
      /// -- AppBar
      appBar: TAppBar(
        title: Text(TTexts.cart.tr ,style: Theme.of(context).textTheme.headlineSmall),
        showBackArrow: true,
        showActions: false,
        showSkipButton: false,
      ),

      body: Obx(() {
        if (controller.loading.value) {
          return const Center(
              child: CircularProgressIndicator(
            color: TColors.primary,
          ));
        }

        if (controller.cartItems.isEmpty) {
          return TAnimationLoaderWidget(
            text: TTexts.whoopCartEmpty.tr,
            animation: TImages.emptyAnimation,
            showAction: true,
            actionText: TTexts.letsFillIt.tr,
            onActionPressed: () => Get.offNamed(TRoutes.homeMenu),
          );
        } else {
          /// Cart Items
          return const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(TSizes.defaultSpace),

              /// -- Items in Cart
              child: TCartItems(),
            ),
          );
        }
      }),

      /// -- Checkout Button
      bottomNavigationBar: Obx(
        () {
          return cartItems.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await settingsController.fetchSettingDetails();
                        Get.to(() => const CheckoutScreen());
                      },
                      child: Obx(() => Text('${TTexts.checkOut.tr} \$ ${controller.totalCartPrice.value}')),
                    ),
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }
}
