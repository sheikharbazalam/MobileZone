import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/table.dart';

class RoleDesktopScreen extends StatelessWidget {
  const RoleDesktopScreen({super.key});

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
              const TBreadcrumbsWithHeading(iconData: Iconsax.task, heading: 'Roles and Permissions', breadcrumbItems: ['Roles']),
              SizedBox(height: TSizes().spaceBtwSections),

              // Body
              SizedBox(height: TSizes().spaceBtwSections),
              PermissionTable(),
            ],
          ),
        ),
      ),
    );
  }
}
