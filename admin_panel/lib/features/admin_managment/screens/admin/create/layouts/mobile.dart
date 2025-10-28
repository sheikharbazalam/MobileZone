import 'package:cwt_ecommerce_admin_panel/features/admin_managment/screens/admin/create/widgets/form.dart';
import 'package:cwt_ecommerce_admin_panel/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:t_utils/t_utils.dart';

class Mobile extends StatelessWidget {
  const Mobile({super.key});

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
                heading: 'Create Admin',
                breadcrumbItems: [TRoutes.admin, 'Create Admin'],
              ),
              SizedBox(height: TSizes().spaceBtwSections),

              // Form
              CreateAdminForm(),
            ],
          ),
        ),
      ),
    );
  }
}
