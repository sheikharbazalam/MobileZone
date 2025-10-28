import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../controllers/chat_controller.dart';
import 'layouts/desktop.dart';
import 'layouts/mobile.dart';

class ChatDetail extends StatelessWidget {
  const ChatDetail({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChatController());
    return const TSiteTemplate(desktop: ChatDesktop(), mobile: ChatMobile());
  }
}
