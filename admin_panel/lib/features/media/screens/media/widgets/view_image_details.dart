import 'package:clipboard/clipboard.dart';
import 'package:cwt_ecommerce_admin_panel/features/media/controllers/media_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_overlay_notification/t_overlay_notification.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../utils/constants/text_strings.dart';
import '../../../models/image_model.dart';

class ImagePopup extends StatelessWidget {
  /// The image model to display detailed information about.
  final ImageModel image;

  /// Constructor for the ImagePopup class.
  const ImagePopup({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        /// Define the shape of the dialog.
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes().borderRadiusLg)),
        child: TContainer(
          /// Set the width of the rounded container based on the screen size.
          width: TDeviceUtils.isDesktopScreen(context) ? MediaQuery.of(context).size.width * 0.4 : double.infinity,
          padding: EdgeInsets.all(TSizes().spaceBtwItems),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Display the image with an option to close the dialog.
              SizedBox(
                child: Stack(
                  children: [
                    // Display the image with rounded container.
                    TContainer(
                      backgroundColor: TColors().lightBackground,
                      child: TImage(
                        image: image.url,
                        applyImageRadius: true,
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: TDeviceUtils.isDesktopScreen(context) ? MediaQuery.of(context).size.width * 0.4 : double.infinity,
                        imageType: ImageType.network,
                      ),
                    ),
                    // Close icon button positioned at the top-right corner.
                    Positioned(top: 0, right: 0, child: IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.close_circle)))
                  ],
                ),
              ),
              const Divider(),
              SizedBox(height: TSizes().spaceBtwItems),

              /// Display various metadata about the image.
              /// Includes image name, path, type, size, creation and modification dates, and URL.
              /// Also provides an option to copy the image URL.
              Row(
                children: [
                  Expanded(
                      child: TTextWithIcon(icon: Iconsax.image, text: TTexts.imageName.tr, textStyle: Theme.of(context).textTheme.bodySmall)),
                  Expanded(flex: 3, child: Text(image.filename, style: Theme.of(context).textTheme.titleLarge)),
                ],
              ),
              SizedBox(height: TSizes().sm),

              /// Image Size
              if (image.sizeBytes != null && image.sizeBytes! > 0)
                Row(
                  children: [
                    Expanded(
                        child: TTextWithIcon(icon: Iconsax.size, text: TTexts.imageSize.tr, textStyle: Theme.of(context).textTheme.bodySmall)),
                    Expanded(
                        flex: 3,
                        child: Text('${((image.sizeBytes ?? 0) / 1024).toStringAsFixed(2)} KB',
                            style: Theme.of(context).textTheme.titleLarge)),
                  ],
                ),
              if (image.sizeBytes != null) SizedBox(height: TSizes().sm),

              /// Image Type
              if (image.contentType != null && image.contentType!.isNotEmpty)
                Row(
                  children: [
                    Expanded(
                        child:
                            TTextWithIcon(icon: Iconsax.activity, text: TTexts.imageType.tr, textStyle: Theme.of(context).textTheme.bodySmall)),
                    Expanded(flex: 3, child: Text(image.contentType ?? '', style: Theme.of(context).textTheme.titleLarge)),
                  ],
                ),
              if (image.contentType != null && image.contentType!.isNotEmpty) SizedBox(height: TSizes().sm),


              Row(
                children: [
                  Expanded(
                      child: TTextWithIcon(icon: Iconsax.clock, text: TTexts.dateCreated.tr, textStyle: Theme.of(context).textTheme.bodySmall)),
                  Expanded(flex: 3, child: Text(image.createdAtFormatted, style: Theme.of(context).textTheme.titleLarge)),
                ],
              ),
              SizedBox(height: TSizes().sm),

              /// Display the image URL with an option to copy it.
              Row(
                children: [
                  Expanded(child: TTextWithIcon(icon: Iconsax.link, text: TTexts.imageUrl.tr, textStyle: Theme.of(context).textTheme.bodySmall)),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Expanded(
                          child:
                              Text(image.url, style: Theme.of(context).textTheme.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        SizedBox(width: TSizes().sm),
                        TIcon(
                          color: TColors().primary,
                          onPressed: () {
                            FlutterClipboard.copy(image.url)
                                .then((value) => TNotificationOverlay.success(context: context, title: TTexts.urlCopied.tr,));
                          },
                          icon: Iconsax.copy,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: TSizes().spaceBtwSections),

              /// Display a button to delete the image.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => MediaController.instance.removeCloudImageConfirmation(image),
                    label: Text(TTexts.deleteImage.tr, style: TextStyle(color: Colors.red)),
                    icon: const Icon(Iconsax.trash, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
