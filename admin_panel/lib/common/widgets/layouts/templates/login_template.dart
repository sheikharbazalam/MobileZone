import 'package:flutter/material.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../utils/constants/image_strings.dart';

/// Template for the login page layout
/// Provides a reusable structure for a login page with responsiveness.
class TLoginTemplate extends StatelessWidget {
  const TLoginTemplate({super.key, required this.child});

  /// The widget to be displayed inside the login template (e.g., forms, buttons).
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: TDeviceUtils.getScreenWidth(context) * 0.9,
        height: TDeviceUtils.getScreenHeight(context) * 0.8,
        child: TContainer(
          // Add rounded corners to the main container.
          borderRadius: BorderRadius.circular(TSizes().borderRadiusLg),
          padding: const EdgeInsets.all(0),
          child: Row(
            children: [
              // Display the login animation only on desktop screens.
              if (TDeviceUtils.isDesktopScreen(context)) Expanded(child: _loginAnimationWidget(context)),

              // Display the content (e.g., login form) on the right side.
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: TSizes().defaultSpace * 2, horizontal: TDeviceUtils.getScreenWidth(context) * 0.1),
                  child: SingleChildScrollView(child: child),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the login animation widget, shown on desktop screens.
  /// Includes an illustration and a footer text.
  TContainer _loginAnimationWidget(BuildContext context) {
    return TContainer(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(TSizes().borderRadiusLg), bottomLeft: Radius.circular(TSizes().borderRadiusLg)),
      padding: const EdgeInsets.all(0),
      backgroundColor: TColors().primary,
      child: SizedBox(
        height: TDeviceUtils.getScreenHeight(context),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Display an image illustration in the center.
            Image(image: AssetImage(TImages.loginLoaderIllustration), fit: BoxFit.none),

            // Add a footer text "Powered by Coding with T." at the bottom.
            Positioned(
              bottom: TSizes().defaultSpace,
              child: Text(
                'Powered by Coding with T.',
                style: Theme.of(context).textTheme.bodyLarge!.apply(color: TColors().white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
