import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../utils/constants/text_strings.dart';
import '../widgets/form.dart';
import '../widgets/image_meta.dart';

class ProfileTabletScreen extends StatelessWidget {
  const ProfileTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes().defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              TBreadcrumbsWithHeading(heading:TTexts.profile.tr, breadcrumbItems: [TTexts.profile.tr]),
              SizedBox(height: TSizes().spaceBtwSections),

              TFormContainer(
                child: Column(
                  children: [
                    ImageAndMeta(),
                    SizedBox(height: TSizes().spaceBtwSections),

                    // Form
                    ProfileForm(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
