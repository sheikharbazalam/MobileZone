import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/chat_controller.dart';
import '../../../../models/chat_model.dart';
import '../../../../models/participant_model.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({
    super.key,
    required this.otherParticipant,
    required this.chat,
  });

  final ParticipantModel otherParticipant;
  final ChatModel chat;

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  bool isHovered = false; // Track hover state

  @override
  Widget build(BuildContext context) {
    final chatController = ChatController.instance;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true), // Set hover to true
      onExit: (_) => setState(() => isHovered = false), // Reset hover on exit
      child: Obx(
        () {
          bool isSelected = chatController.currentChatId.value == widget.chat.id;
          return TContainer(
            padding: EdgeInsets.symmetric(horizontal: TSizes().sm, vertical: TSizes().xs),
            backgroundColor: isSelected
                ? TColors().primary.withValues(alpha: 0.2) // Selected chat color
                : isHovered
                    ? Colors.grey.withValues(alpha: 0.2) // Hover effect color
                    : Colors.grey.withValues(alpha: 0.05),
            child: ListTile(
              leading: widget.otherParticipant.profileImageURL.isNotEmpty
                  ? TImage(
                      image: widget.otherParticipant.profileImageURL,
                      imageType: ImageType.network,
                      padding: 0,
                      width: 40,
                      height: 40,
                    )
                  : CircleAvatar(child: Text(widget.otherParticipant.name[0])),
              title: Text(
                widget.otherParticipant.name.isNotEmpty
                    ? widget.otherParticipant.name
                    : widget.chat.chatType == ChatType.support
                        ? TTexts.support.tr
                        : 'UnKnown',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                widget.chat.lastMessageType == MessageType.text
                    ? widget.chat.lastMessage.isNotEmpty
                        ? widget.chat.lastMessage
                        : TTexts.noRecentMessage.tr
                    : widget.chat.lastMessageType == MessageType.audio
                        ? TTexts.audioMessage.tr
                        : widget.chat.lastMessageType == MessageType.image
                            ? TTexts.image.tr
                            : '',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              trailing: Text(
                TimeOfDay.fromDateTime(widget.chat.lastMessageTime).format(context),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                chatController.selectedChat.value = widget.chat;
                chatController.currentChatId.value = widget.chat.id;
                chatController.currentChat.value = widget.chat;
                chatController.fetchMessages();
              },
            ),
          );
        },
      ),
    );
  }
}
