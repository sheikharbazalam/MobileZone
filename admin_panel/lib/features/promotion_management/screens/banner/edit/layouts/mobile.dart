import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:t_utils/t_utils.dart';
import '../../../../../../routes/routes.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../widgets/form.dart';

class MobileScreen extends StatelessWidget {
  const MobileScreen({super.key});

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
              TBreadcrumbsWithHeading(
                  returnToPreviousScreen: true, heading: TTexts.updateBanner.tr, breadcrumbItems: [TRoutes.banners,  TTexts.updateBanner.tr]),
              SizedBox(height: TSizes().spaceBtwSections),

              // Form
              EditBannerForm(),
            ],
          ),
        ),
      ),
    );
  }
}
