import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/product/product_images_controller.dart';

class ProductAdditionalImages extends StatelessWidget {
  const ProductAdditionalImages({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductImagesController());
    return Obx(
      () => TContainer(
        child: Column(
          children: [
            TTextWithIcon(text: TTexts.additionalImages.tr, icon: Iconsax.picture_frame),
            SizedBox(height: TSizes().spaceBtwItems),
            SizedBox(
              height: 300,
              child: Column(
                children: [
                  // Section to Add Additional Product Images
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () => controller.selectMultipleProductImages(),
                      child: Image.asset(TImages.defaultMultiImageIcon, width: 150, height: 150),
                    ),
                  ),

                  // Section to Display Uploaded Images
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: SizedBox(height: 80, child: _uploadedImagesOrEmptyList(controller))),
                        SizedBox(width: TSizes().spaceBtwItems / 2),

                        // Add More Images Button
                        TContainer(
                          width: 80,
                          height: 80,
                          showRipple: true,
                          showBorder: true,
                          borderColor: TColors().grey,
                          backgroundColor: TColors().white,
                          onTap: () => controller.selectMultipleProductImages(),
                          child: const Center(child: Icon(Iconsax.add)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to Display Either Uploaded Images or Empty List
  Widget _uploadedImagesOrEmptyList(ProductImagesController controller) {
    return controller.additionalProductImagesUrls.isNotEmpty ? _uploadedImages(controller) : emptyList();
  }

  // Widget to Display Empty List Placeholder
  Widget emptyList() {
    return ListView.separated(
      itemCount: 6,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) => SizedBox(width: TSizes().spaceBtwItems / 2),
      itemBuilder: (context, index) => TContainer(backgroundColor: TColors().lightBackground, width: 80, height: 80),
    );
  }

  // Widget to Display Uploaded Images
  ListView _uploadedImages(ProductImagesController controller) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: controller.additionalProductImagesUrls.length,
      separatorBuilder: (context, index) => SizedBox(width: TSizes().spaceBtwItems / 2),
      itemBuilder: (context, index) {
        final image = controller.additionalProductImagesUrls[index];
        return TImageUploader(
          top: 0,
          right: 0,
          width: 80,
          height: 80,
          left: null,
          bottom: null,
          image: image,
          icon: Iconsax.trash,
          imageType: ImageType.network,
          onIconButtonPressed: () => controller.removeImage(index),
        );
      },
    );
  }
}
