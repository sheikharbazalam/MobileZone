// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:t_utils/utils/constants/colors.dart';
//
// import '../../../../../../common/widgets/images/t_rounded_image.dart';
// import '../../../../../../utils/exports.dart';
// import '../../../../controllers/create_driver_controller.dart';
//
// class ImageUploaderWithUploadButton extends StatelessWidget {
//   const ImageUploaderWithUploadButton({
//     super.key,
//     required this.controller,
//     required this.heading,
//     required this.subHeading,
//     required this.documentType,
//     required this.imageURL,
//   });
//
//   final CreateDriverController controller;
//   final String heading, subHeading;
//   final DocumentType documentType;
//   final RxString imageURL;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: TSizes.spaceBtwItems),
//         Text(heading, style: Theme.of(context).textTheme.headlineSmall),
//         Text(subHeading, style: Theme.of(context).textTheme.labelLarge),
//         const SizedBox(height: TSizes.spaceBtwItems),
//         OutlinedButton.icon(
//           style: OutlinedButton.styleFrom(backgroundColor: TColors.primaryBackground),
//           onPressed: () => controller.selectImageFromMedia(documentType),
//           label: Text(TTexts.uploadImage, style: Theme.of(context).textTheme.titleLarge),
//           icon: const Icon(Iconsax.image),
//         ),
//         Obx(
//               () => imageURL.value.isNotEmpty
//               ? TRoundedImage(
//             width: 200,
//             height: 200,
//             imageType: imageURL.value.isNotEmpty ? ImageType.network : ImageType.asset,
//             image: imageURL.value.isNotEmpty ? imageURL.value : TImages.truckWithUser,
//           )
//               : const SizedBox.shrink(),
//         ),
//         const SizedBox(height: TSizes.spaceBtwItems),
//       ],
//     );
//   }
// }