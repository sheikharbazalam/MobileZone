import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tstore_ecommerce_app/utils/constants/text_strings.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../controllers/onboarding_controller.dart';


class TOnBoardingSkipButton extends StatelessWidget {
  const TOnBoardingSkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;

    return Positioned(
      top: TDeviceUtils.getAppBarHeight(),
      right: TSizes.defaultSpace,
      child: TextButton(onPressed: controller.skipPage, child: Text(TTexts.skip.tr)),
    );
  }
}
