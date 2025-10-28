import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../utils/constants/image_strings.dart';
import '../../../controllers/user_controller.dart';

class ImageAndMeta extends StatelessWidget {
  const ImageAndMeta({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    return Column(
      children: [
        SizedBox(height: TSizes().spaceBtwSections),
        // User Image
        Obx(
          () => TImageUploader(
            right: 0,
            bottom: 0,
            left: 0,
            width: 200,
            height: 200,
            icon: Iconsax.camera,
            loading: controller.loading.value,
            onIconButtonPressed: () => controller.updateProfilePicture(),
            imageType: controller.user.value.profilePicture.isNotEmpty ? ImageType.network : ImageType.asset,
            image: controller.user.value.profilePicture.isNotEmpty ? controller.user.value.profilePicture : TImages.user,
          ),
        ),
        SizedBox(height: TSizes().spaceBtwItems),
        Obx(() => Text(controller.user.value.fullName, style: Theme.of(context).textTheme.headlineLarge)),
        Obx(() => Text(controller.user.value.email)),
      ],
    );
  }
}
