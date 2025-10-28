import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:t_utils/utils/constants/sizes.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../chat/messages_screen.dart';

class ChatMobile extends StatelessWidget {
  const ChatMobile({super.key});

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
                heading: TTexts.messages.tr,
                breadcrumbItems: [TRoutes.chats, TTexts.messages.tr],
              ),
              SizedBox(height: TSizes().spaceBtwSections),

              // Form
              MessagesScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
