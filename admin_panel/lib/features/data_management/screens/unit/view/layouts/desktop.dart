import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


import 'package:t_utils/t_utils.dart';

import '../widgets/table.dart';

class UnitsDesktopScreen extends StatelessWidget {
  const UnitsDesktopScreen({super.key});

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
              TBreadcrumbsWithHeading(iconData: Iconsax.unlimited, heading: 'All Units', breadcrumbItems: ['All Units']),
              SizedBox(height: TSizes().spaceBtwSections),

              // Body
              UnitTable(),
            ],
          ),
        ),
      ),
    );
  }
}
