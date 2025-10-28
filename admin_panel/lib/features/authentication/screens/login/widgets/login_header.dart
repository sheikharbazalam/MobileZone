import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/utils/constants/sizes.dart';

import '../../../../../../utils/constants/image_strings.dart';

import '../../../../../../utils/constants/text_strings.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Image(width: 100, height: 100, image: AssetImage(TImages.darkAppLogo)),
          SizedBox(height: TSizes().spaceBtwSections),
          Text(TTexts.loginTitle.tr, style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: TSizes().sm),
          Text(TTexts.loginSubTitle.tr, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
