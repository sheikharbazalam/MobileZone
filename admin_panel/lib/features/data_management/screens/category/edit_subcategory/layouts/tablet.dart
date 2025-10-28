import 'package:flutter/material.dart';


import 'package:t_utils/t_utils.dart';
import '../../../../../../routes/routes.dart';

import '../widgets/form.dart';

class TabletScreen extends StatelessWidget {
  const TabletScreen({super.key});

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
                  returnToPreviousScreen: true, heading: 'Update SubCategory', breadcrumbItems: [TRoutes.categories, 'Update SubCategory']),
              SizedBox(height: TSizes().spaceBtwSections),

              // Form
              EditSubCategoryForm(),
            ],
          ),
        ),
      ),
    );
  }
}
