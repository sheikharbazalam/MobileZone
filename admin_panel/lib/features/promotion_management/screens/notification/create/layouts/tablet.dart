import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:t_utils/t_utils.dart';
import '../../../../../../routes/routes.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../widgets/form.dart';

class TabletScreen extends StatelessWidget {
  const TabletScreen({
    super.key,
  });

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
                returnToPreviousScreen: true,
                heading: TTexts.createNotification.tr,
                breadcrumbItems: [TRoutes.notifications, TTexts.createNotification.tr],
              ),
              SizedBox(height: TSizes().spaceBtwSections),

              // Form
              CreateNotificationForm(),
            ],
          ),
        ),
      ),
    );
  }
}
