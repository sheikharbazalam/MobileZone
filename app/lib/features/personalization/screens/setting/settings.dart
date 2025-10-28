import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tstore_ecommerce_app/utils/constants/text_strings.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/list_tiles/settings_menu_tile.dart';
import '../../../../common/widgets/list_tiles/user_profile_tile.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../home_menu.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/user_controller.dart';
import '../address/address.dart';
import '../profile/profile.dart';
import 'upload_data.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.offAll(const HomeMenu());
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              /// -- Header
              TPrimaryHeaderContainer(
                child: Column(
                  children: [
                    /// AppBar
                    TAppBar(
                      title: Text(TTexts.account.tr, style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.white)),
                      showActions: false,
                      showSkipButton: false,
                    ),

                    /// User Profile Card
                    TUserProfileTile(onPressed: () => Get.to(() => const ProfileScreen())),
                    const SizedBox(height: TSizes.spaceBtwSections),
                  ],
                ),
              ),

              /// -- Profile Body
              Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// -- Account  Settings
                    TSectionHeading(title: TTexts.accountSetting.tr, showActionButton: false),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TSettingsMenuTile(
                      icon: Iconsax.safe_home,
                      title: TTexts.myAddress.tr,
                      subTitle: TTexts.addressSubTitle.tr,
                      onTap: () => Get.to(() => const UserAddressScreen()),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.shopping_cart,
                      title: TTexts.myCart.tr,
                      subTitle: TTexts.cartSubTitle.tr,
                      onTap: () => Get.toNamed(TRoutes.cart),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.bag_tick,
                      title: TTexts.myOrders.tr,
                      subTitle: TTexts.ordersSubTitle.tr,
                      onTap: () => Get.toNamed(TRoutes.order),
                    ),
                    TSettingsMenuTile(
                        icon: Iconsax.bank, title: TTexts.bankAccount.tr, subTitle:TTexts.bankAccountSubTitle.tr),
                    TSettingsMenuTile(
                      icon: Iconsax.discount_shape,
                      title: TTexts.myCoupons.tr,
                      subTitle: TTexts.myCouponsSubTitle.tr,
                      onTap: () => Get.toNamed(TRoutes.coupon),
                    ),
                    TSettingsMenuTile(
                      title: TTexts.languages.tr,
                      icon: Icons.language,
                      onTap: () => Get.toNamed(TRoutes.language),
                      subTitle: '',
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.notification,
                      title: TTexts.notifications.tr,
                      subTitle: TTexts.notificationsSubTitle.tr,
                      onTap: () => Get.toNamed(TRoutes.notification),
                    ),
                    TSettingsMenuTile(
                        icon: Iconsax.security_card,
                        title: TTexts.accountPrivacy.tr,
                        subTitle:TTexts.accountPrivacySubTitle.tr),

                    /// -- App Settings
                    const SizedBox(height: TSizes.spaceBtwSections),
                    TSectionHeading(title:TTexts.appSetting.tr, showActionButton: false),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TSettingsMenuTile(
                      icon: Iconsax.document_upload,
                      title: TTexts.loadData.tr,
                      subTitle: TTexts.loadDataSubTitle.tr,
                      onTap: () => Get.to(() => const UploadDataScreen()),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.support,
                      title: TTexts.chat.tr,
                      subTitle: TTexts.chatSubTitle.tr,
                      onTap: () => Get.toNamed(TRoutes.chatList),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.location,
                      title: TTexts.geolocation.tr,
                      subTitle: TTexts.geolocationSubTitle.tr,
                      trailing: Switch(value: true, onChanged: (value) {}),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.security_user,
                      title: TTexts.safeMode.tr,
                      subTitle: TTexts.safeModeSubTitle.tr,
                      trailing: Switch(value: false, onChanged: (value) {}),
                    ),
                    TSettingsMenuTile(
                      icon: Iconsax.image,
                      title: TTexts.hdImage.tr,
                      subTitle: TTexts.hdImageSubTitle.tr,
                      trailing: Switch(value: false, onChanged: (value) {}),
                    ),

                    /// -- Logout Button
                    const SizedBox(height: TSizes.spaceBtwSections),
                    SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(onPressed: () => controller.logout(), child: Text(TTexts.logout.tr))),
                    const SizedBox(height: TSizes.spaceBtwSections * 2.5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
