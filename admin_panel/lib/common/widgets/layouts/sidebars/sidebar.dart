import 'package:cwt_ecommerce_admin_panel/features/personalization/controllers/user_controller.dart';
import 'package:cwt_ecommerce_admin_panel/features/role_management/controllers/role/role_controller.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';
import '../../../../features/personalization/controllers/settings_controller.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import 'menu/menu_item.dart';

/// Sidebar widget for navigation menu
class TSidebar extends StatelessWidget {
  const TSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final roleController = RoleController.instance;

    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: BoxDecoration(
          color: TColors().darkBackground,
          border: Border(right: BorderSide(width: 1, color: TColors().grey)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              _logoAndName(context),
              SizedBox(height: TSizes().spaceBtwSections),

              /// Menu
              Obx(
                () {
                  final role = UserController.instance.user.value.role;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: TSizes().defaultSpace),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Section 1
                        Text(
                          TTexts.sidebarOverviewMedia.tr,
                          style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2, color: TColors().white),
                        ),
                        // Menu Items
                        const TMenuItem(route: TRoutes.dashboard, icon: Iconsax.status, itemName: 'Dashboard'),
                        roleController.hasPermission(role, Permission.viewMedia)
                            ? TMenuItem(route: TRoutes.media, icon: Iconsax.gallery, itemName: 'Media')
                            : SizedBox.shrink(),
                        SizedBox(height: TSizes().spaceBtwSections),

                        /// Section 2
                        if (roleController.hasPermission(role, Permission.viewCategory) ||
                            roleController.hasPermission(role, Permission.viewSubCategory) ||
                            roleController.hasPermission(role, Permission.viewBrand) ||
                            roleController.hasPermission(role, Permission.viewAttribute) ||
                            roleController.hasPermission(role, Permission.viewUnit)) ...[
                          Text(
                            TTexts.sidebarDataManagement.tr,
                            style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2, color: TColors().white),
                          ),
                          roleController.hasPermission(role, Permission.viewCategory)
                              ? TMenuItem(route: TRoutes.categories, icon: Iconsax.category_2, itemName: TTexts.sidebarCategories.tr,)
                              : SizedBox.shrink(),
                          roleController.hasPermission(role, Permission.viewSubCategory)
                              ? TMenuItem(route: TRoutes.subCategories, icon: Iconsax.category5, itemName: TTexts.sidebarSubCategories.tr,)
                              : SizedBox.shrink(),
                          roleController.hasPermission(role, Permission.viewBrand)
                              ? TMenuItem(route: TRoutes.brands, icon: Iconsax.dcube, itemName: TTexts.sidebarBrands.tr)
                              : SizedBox.shrink(),
                          roleController.hasPermission(role, Permission.viewAttribute)
                              ? TMenuItem(route: TRoutes.attributes, icon: Iconsax.activity, itemName: TTexts.sidebarAttributes.tr)
                              : SizedBox.shrink(),
                          roleController.hasPermission(role, Permission.viewUnit)
                              ? TMenuItem(route: TRoutes.units, icon: Iconsax.unlimited, itemName: TTexts.sidebarUnits.tr)
                              : SizedBox.shrink(),
                          SizedBox(height: TSizes().spaceBtwSections),
                        ],

                        /// Section 3
                        if (roleController.hasPermission(role, Permission.createProducts) ||
                            roleController.hasPermission(role, Permission.viewProducts) ||
                            roleController.hasPermission(role, Permission.viewRecommendedProduct) ||
                            roleController.hasPermission(role, Permission.viewUsers) ||
                            roleController.hasPermission(role, Permission.viewOrders) ||
                            roleController.hasPermission(role, Permission.viewReview)) ...[
                          Text(
                            TTexts.sidebarProductManagement.tr,
                            style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2, color: TColors().white),
                          ),
                          roleController.hasPermission(role, Permission.createProducts)
                              ? TMenuItem(route: TRoutes.createProduct, icon: Iconsax.box_add, itemName: TTexts.sidebarAddNewProduct.tr)
                              : SizedBox.shrink(),
                          roleController.hasPermission(role, Permission.viewProducts)
                              ? TMenuItem(route: TRoutes.products, icon: Iconsax.shopping_cart, itemName: TTexts.sidebarProducts.tr)
                              : SizedBox.shrink(),
                          roleController.hasPermission(role, Permission.viewRecommendedProduct)
                              ? TMenuItem(
                                  route: TRoutes.recommendedProducts,
                                  icon: Iconsax.heart_circle,
                                  itemName: TTexts.sidebarRecommendedProducts.tr,
                                )
                              : SizedBox.shrink(),
                          roleController.hasPermission(role, Permission.viewUsers)
                              ? TMenuItem(route: TRoutes.customers, icon: Iconsax.profile_2user, itemName: TTexts.sidebarCustomers.tr,)
                              : SizedBox.shrink(),
                          roleController.hasPermission(role, Permission.viewOrders)
                              ? TMenuItem(route: TRoutes.orders, icon: Iconsax.box, itemName: TTexts.sidebarOrders.tr)
                              : SizedBox.shrink(),
                          roleController.hasPermission(role, Permission.viewReview)
                              ? TMenuItem(route: TRoutes.reviews, icon: Iconsax.star, itemName: TTexts.sidebarProductReviews.tr)
                              : SizedBox.shrink(),
                          SizedBox(height: TSizes().spaceBtwSections),
                        ],

                        /// Section 4
                        if (roleController.hasPermission(role, Permission.viewBanner) ||
                            roleController.hasPermission(role, Permission.viewCoupon)) ...[
                          Text(
                            TTexts.sidebarPromotionManagement.tr,
                            style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2, color: TColors().white),
                          ),
                          roleController.hasPermission(role, Permission.viewBanner)
                              ? TMenuItem(route: TRoutes.banners, icon: Iconsax.picture_frame, itemName: TTexts.sidebarBanners.tr)
                              : SizedBox.shrink(),
                          roleController.hasPermission(role, Permission.viewCoupon)
                              ? TMenuItem(route: TRoutes.coupons, icon: Iconsax.discount_shape, itemName: TTexts.sidebarCoupons.tr)
                              : SizedBox.shrink(),
                          SizedBox(height: TSizes().spaceBtwSections),
                        ],

                        if (roleController.hasPermission(role, Permission.viewNotifications)) ...[
                          Text(
                  TTexts.sidebarNotification.tr,
                            style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2, color: TColors().white),
                          ),
                          roleController.hasPermission(role, Permission.viewNotifications)
                              ? TMenuItem(route: TRoutes.notifications, icon: Iconsax.notification, itemName: TTexts.sidebarNotifications.tr,)
                              : SizedBox.shrink(),
                          SizedBox(height: TSizes().spaceBtwSections),
                        ],

                        // Support Management
                        Text(TTexts.sidebarSupportManagement.tr,
                            style: Theme.of(context).textTheme.labelLarge!.apply(letterSpacingDelta: 1.2, color: TColors().white)),
                        // const TMenuItem(route: TRoutes.supportTickets, icon: Iconsax.message, itemName: 'Support Tickets'),
                         TMenuItem(route: TRoutes.chats, icon: Iconsax.messages, itemName: TTexts.sidebarChat.tr),
                        SizedBox(height: TSizes().spaceBtwSections),

                        // Users Section
                        if (roleController.hasPermission(role, Permission.viewUsers)) ...[
                          Text(
                           'ADMIN MANAGEMENT',
                            style: Theme.of(context).textTheme.labelLarge!.apply(letterSpacingDelta: 1.2, color: TColors().white),
                          ),
                          roleController.hasPermission(role, Permission.viewUsers)
                              ? TMenuItem(route: TRoutes.admin, icon: Iconsax.profile_2user, itemName: 'Admin')
                              : SizedBox.shrink(),
                          SizedBox(height: TSizes().spaceBtwSections),
                        ],

                        /// -- Roles
                        if (roleController.hasPermission(role, Permission.viewRoles)) ...[
                          roleController.hasPermission(role, Permission.viewRoles)
                              ? Text(
                                  'ROLE MANAGEMENT',
                                  style: Theme.of(context).textTheme.labelLarge!.apply(letterSpacingDelta: 1.2, color: TColors().white),
                                )
                              : SizedBox.shrink(),
                          roleController.hasPermission(role, Permission.viewRoles)
                              ? TMenuItem(route: TRoutes.roles, icon: Iconsax.task, itemName: 'Roles')
                              : SizedBox.shrink(),
                          SizedBox(height: TSizes().spaceBtwSections),
                        ],

                        /// Section 4
                        Text(
                          TTexts.sidebarConfigurations.tr,
                          style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2, color: TColors().white),
                        ),
                        TMenuItem(route: TRoutes.profile, icon: Iconsax.discount_shape, itemName: TTexts.sidebarProfile.tr),
                        roleController.hasPermission(role, Permission.viewSettings)
                            ? TMenuItem(route: TRoutes.settings, icon: Iconsax.picture_frame, itemName: TTexts.sidebarAppSettings.tr)
                            : SizedBox.shrink(),
                        SizedBox(height: TSizes().spaceBtwSections),
                        TMenuItem(route: 'logout', icon: Iconsax.logout, itemName: TTexts.sidebarLogout.tr),
                        SizedBox(height: TSizes().defaultSpace),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoAndName(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(TRoutes.settings),
      child: Row(
        children: [
          Obx(
            () => TImage(
              width: 60,
              height: 60,
              padding: 0,
              margin: TSizes().sm,
              backgroundColor: Colors.transparent,
              imageType: SettingsController.instance.settings.value.appLogo.isNotEmpty ? ImageType.network : ImageType.asset,
              image: SettingsController.instance.settings.value.appLogo.isNotEmpty
                  ? SettingsController.instance.settings.value.appLogo
                  : TImages.darkAppLogo,
            ),
          ),
          Expanded(
            child: Obx(
              () => Text(
                SettingsController.instance.settings.value.appName,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white, // Set text color to white
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
