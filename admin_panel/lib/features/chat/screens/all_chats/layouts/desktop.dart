import 'package:flutter/material.dart';
import 'package:t_utils/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:t_utils/utils/constants/sizes.dart';

import '../chat_screen/chat_screen.dart';

class Desktop extends StatelessWidget {
  const Desktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes().defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// -- Breadcrumbs
              const TBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Support',
                breadcrumbItems: ['Support'],
              ),
              SizedBox(height: TSizes().spaceBtwSections),

              /// -- Chat Screen
              const ChatScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
