import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/products/cart/cart_menu_icon.dart';
import '../../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../personalization/controllers/settings_controller.dart';
import '../../../../personalization/controllers/user_controller.dart';
import '../../../../personalization/screens/profile/profile.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Just to create instance and fetch values
    Get.put(SettingsController());
    final userController = Get.put(UserController());

    return TAppBar(
      title: GestureDetector(
        onTap: () => Get.to(() => const ProfileScreen()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(TTexts.homeAppbarTitle.tr, style: Theme.of(context).textTheme.labelMedium!.apply(color: TColors.grey)),
            Obx(() {
              // Check if user Profile is still loading
              if (userController.profileLoading.value) {
                // Display a shimmer loader while user profile is being loaded
                return const TShimmerEffect(width: 80, height: 15);
              } else {
                // Check if there are no record found
                if (userController.user.value.id.isEmpty) {
                  // Display a message when no data is found
                  return Text('Your Name', style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white));
                } else {
                  // Display User Name
                  return Text(
                    userController.user.value.fullName.isNotEmpty
                        ? userController.user.value.fullName
                        : userController.user.value.phoneNumber.isNotEmpty
                        ? userController.user.value.phoneNumber
                        : 'Your Name',
                    style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white),
                  );
                }
              }
            }),
          ],
        ),
      ),
      actions: [
        IconButton(icon: const Icon(Iconsax.notification, color: TColors.white), onPressed: () => Get.toNamed(TRoutes.notification)),
        const TCartCounterIcon(iconColor: TColors.white, counterBgColor: TColors.black, counterTextColor: TColors.white),
      ],
      showActions: true,
      showSkipButton: false,
    );
  }
}
