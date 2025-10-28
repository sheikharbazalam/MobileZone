import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/text_strings.dart';
import '../widgets/table.dart';

class AttributesDesktopScreen extends StatelessWidget {
  const AttributesDesktopScreen({super.key});

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
              TBreadcrumbsWithHeading(iconData: Iconsax.activity, heading: TTexts.allAttributes.tr, breadcrumbItems: [TTexts.allAttributes.tr]),
              SizedBox(height: TSizes().spaceBtwSections),

              // Body
              AttributeTable(),
            ],
          ),
        ),
      ),
    );
  }
}
