import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:t_utils/common/widgets/containers/form_container.dart';
import 'package:t_utils/utils/constants/sizes.dart';

import '../../../../../utils/constants/text_strings.dart';
import '../widgets/form.dart';
import '../widgets/image_meta.dart';

class ProfileDesktopScreen extends StatelessWidget {
  const ProfileDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: TSizes().defaultSpace * 2, horizontal: TSizes().defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              TBreadcrumbsWithHeading(heading: TTexts.profile.tr, breadcrumbItems: [TTexts.profile.tr]),
              SizedBox(height: TSizes().spaceBtwSections),

              // Body
              TFormContainer(
                child: Column(
                  children: [
                    ImageAndMeta(),

                    SizedBox(height: TSizes().spaceBtwItems),
                    Divider(),
                    SizedBox(height: TSizes().spaceBtwItems),

                    // Form
                    ProfileForm(),
                    SizedBox(height: TSizes().spaceBtwSections),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
