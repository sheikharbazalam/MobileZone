import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../chat/screens/all_chats/layouts/desktop.dart';
import '../../../chat/screens/all_chats/layouts/mobile.dart';
import '../../controllers/chat_controller.dart';

class AllChatsScreen extends StatelessWidget {
  const AllChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChatController());
    return const TSiteTemplate(desktop: Desktop(), mobile: Mobile());
  }
}
