import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/product/product_images_controller.dart';

class ProductThumbnailImage extends StatelessWidget {
  const ProductThumbnailImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ProductImagesController controller = Get.put(ProductImagesController());

    return TContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Text
          TTextWithIcon(text: TTexts.productThumbnail.tr, icon: Iconsax.image),
          SizedBox(height: TSizes().spaceBtwItems),

          // Container for Product Thumbnail
          TContainer(
            height: 300,
            backgroundColor: TColors().lightBackground,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Thumbnail Image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Obx(
                          () => TImage(
                            width: 220,
                            height: 220,
                            image: controller.selectedThumbnailImageUrl.value ?? TImages.defaultMediaImage,
                            imageType: controller.selectedThumbnailImageUrl.value == null ? ImageType.asset : ImageType.network,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Add Thumbnail Button
                  SizedBox(
                    width: 200,
                    child: OutlinedButton(
                      onPressed: () => controller.selectThumbnailImage(),
                      child: Text(TTexts.addThumbnail.tr),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
