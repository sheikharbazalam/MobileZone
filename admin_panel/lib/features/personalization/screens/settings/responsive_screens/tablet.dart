import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:t_utils/t_utils.dart';

import '../../../../../utils/constants/text_strings.dart';
import '../widgets/settings_form.dart';

class SettingsTabletScreen extends StatelessWidget {
  const SettingsTabletScreen({super.key});

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
              TBreadcrumbsWithHeading(heading: TTexts.breadcrumbSettings.tr, breadcrumbItems: [TTexts.breadcrumbSettings.tr]),
              SizedBox(height: TSizes().spaceBtwSections),

              // Body
              TFormContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form
                    SettingsForm()
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
