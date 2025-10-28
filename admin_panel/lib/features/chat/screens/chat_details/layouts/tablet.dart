import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:t_utils/utils/constants/sizes.dart';

import '../../../../../utils/constants/text_strings.dart';

class DriverTabletScreen extends StatelessWidget {
  const DriverTabletScreen({super.key});

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
              TBreadcrumbsWithHeading(heading: TTexts.profile.tr, breadcrumbItems: ['Profile']),
              SizedBox(height: TSizes().spaceBtwSections),

            ],
          ),
        ),
      ),
    );
  }
}
