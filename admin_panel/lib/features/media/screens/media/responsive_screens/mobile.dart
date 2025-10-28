import 'package:cwt_ecommerce_admin_panel/features/role_management/controllers/role/role_controller.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/media_controller.dart';
import '../widgets/media_content.dart';
import '../widgets/media_uploader.dart';

class MediaMobileScreen extends StatelessWidget {
  const MediaMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MediaController());
    final roleController = RoleController.instance;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: TDeviceUtils.getScreenHeight(context),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(TSizes().defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    TBreadcrumbsWithHeading(heading:TTexts.mediaManager.tr, breadcrumbItems: ['Media']),
                    SizedBox(height: TSizes().spaceBtwItems),

                    roleController.checkUserPermission(Permission.createMedia) ?
                    SizedBox(
                      width: TSizes().buttonWidth * 1.5,
                      child: ElevatedButton.icon(
                        label: Text(TTexts.uploadImages.tr),
                        icon: const Icon(Iconsax.cloud_add),
                        onPressed: () => controller.showImagesUploaderSection.value = !controller.showImagesUploaderSection.value,
                      ),
                    ) : SizedBox.shrink(),
                    SizedBox(height: TSizes().spaceBtwSections),

                    /// Media
                    MediaContent(),
                  ],
                ),
              ),
            ),
          ),

          /// Upload Area
          Obx(
            () => AnimatedPositioned(
              bottom: 0,
              height: TDeviceUtils.getScreenHeight(context),
              right: controller.showImagesUploaderSection.value ? 0 : -TDeviceUtils.getScreenWidth(context),
              duration: const Duration(milliseconds: 200),
              child: const MediaUploader(isSideBar: true),
            ),
          ),
        ],
      ),
    );
  }
}
