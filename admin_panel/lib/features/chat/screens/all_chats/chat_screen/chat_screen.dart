import 'package:flutter/material.dart';
import 'package:t_utils/common/widgets/containers/t_container.dart';
import 'package:t_utils/utils/constants/sizes.dart';
import 'package:t_utils/utils/device/device_utility.dart';

import '../../../controllers/chat_controller.dart';
import 'widgets/chat_list.dart';
import 'widgets/chat_view_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChatController.instance;
    return Column(
      spacing: TSizes().spaceBtwSections,
      children: [
        /// -- Chat List and Selected Chat View
        Column(
          children: [
            SizedBox(
              height: TDeviceUtils.getScreenHeight(context) * 0.7 + (TDeviceUtils.isDesktopScreen(context) ? 70 : 130),
              child: TDeviceUtils.isDesktopScreen(context) ? Row(
                spacing: TSizes().spaceBtwItems,
                children: [
                  /// -- Sidebar with chat list
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 350),
                    child: TContainer(
                      width: TDeviceUtils.getScreenWidth(context) * 0.2,
                      child: const ChatList(),
                    ),
                  ),

                  /// --  Chat View
                  Flexible(child: TContainer(child: ChatView())),
                ],
              ):Column(
                spacing: TSizes().spaceBtwItems,
                children: [
                  /// -- Sidebar with chat list
                  TContainer(
                    child: const ChatList(),
                  ),

                  /// --  Chat View
                  Flexible(child: TContainer(child: ChatView())),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
