import 'package:flutter/material.dart';


import 'package:t_utils/t_utils.dart';
import '../../../../../../routes/routes.dart';

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
              TBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Create Sub Category',
                breadcrumbItems: [TRoutes.categories, 'Create Sub Category'],
              ),
              SizedBox(height: TSizes().spaceBtwSections),

              // Form
              CreateSubCategoryForm(),
            ],
          ),
        ),
      ),
    );
  }
}
