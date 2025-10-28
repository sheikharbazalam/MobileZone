import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/common/widgets/containers/t_container.dart';
import 'package:t_utils/common/widgets/texts/text_with_icon.dart';
import 'package:t_utils/utils/constants/sizes.dart';

import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../personalization/controllers/user_controller.dart';
import '../../../../controllers/chat_controller.dart';
import 'empty_chat_view.dart';

class ChatView extends StatelessWidget {
  ChatView({super.key});

  final ChatController chatController = Get.find();
  final UserController userController = Get.find();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final chat = chatController.currentChat.value;

      if (chat.id.isEmpty) return const EmptyChatView();

      // Map messages to the format required by flutter_chat_ui
      List<types.Message> messages = chatController.messages.map((message) {
        switch (message.type) {
          case MessageType.text:
            return types.TextMessage(
              id: message.id,
              showStatus: true,
              text: message.content,
              type: types.MessageType.text,
              author: types.User(id: message.senderId),
              createdAt: message.timestamp.millisecondsSinceEpoch,
              status: mapMessageStatus(message.status),
            );
          case MessageType.audio:
            return types.AudioMessage(
              id: message.id,
              showStatus: true,
              uri: message.content,
              size: message.size ?? 10,
              duration: message.audioDuration ?? const Duration(seconds: 5),
              waveForm: message.audioWaveData,
              name: 'Audio',
              type: types.MessageType.audio,
              author: types.User(id: message.senderId),
              createdAt: message.timestamp.millisecondsSinceEpoch,
              status: mapMessageStatus(message.status),
            );
          case MessageType.image:
            return types.ImageMessage(
              id: message.id,
              showStatus: true,
              uri: message.content,
              name: 'Image',
              size: 10,
              type: types.MessageType.image,
              author: types.User(id: message.senderId),
              createdAt: message.timestamp.millisecondsSinceEpoch,
              status: mapMessageStatus(message.status),
            );
        }
      }).toList();

      return Column(
        children: [
          // Chat header
          TTextWithIcon(text: TTexts.messages.tr, icon: Iconsax.message),

          Expanded(
            child: Chat(
              messages: messages,
              onSendPressed: (partialText) {},
              user: types.User(
                id: userController.user.value.id,
                imageUrl: userController.user.value.profilePicture,
                role: types.Role.admin,
                firstName: userController.user.value.firstName,
                lastName: userController.user.value.lastName,
              ),
              showUserNames: true,
              showUserAvatars: true,
              usePreviewData: true,
              customBottomWidget: _buildCustomInputToolbar(context),
              textMessageOptions: const TextMessageOptions(isTextSelectable: true),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCustomInputToolbar(context) {
    return TContainer(
      margin: EdgeInsets.all(TSizes().defaultSpace / 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      backgroundColor: const Color(0xff1d1c21),
      child: Column(
        children: [
          // if (audioController.isRecording.value) VoiceMessageRecorder(),
          //  Row(
          //    children: [
          //      /// Attachments OR Trash
          //      if (audioController.isRecording.value)
          //        const IconButton(
          //          icon: const Icon(Iconsax.trash, color: Colors.red),
          //          onPressed: () => audioController.cancelRecording(),
          //        ),
          //      if (!audioController.isRecording.value)
          //        if (chatController.isSendingAttachment.value)
          //          const CircularProgressIndicator(color: Colors.white, strokeWidth: 1)
          //        else
          //          const IconButton(
          //            icon: const Icon(Iconsax.attach_circle, color: Colors.grey),
          //            onPressed: _handleAttachmentPressed, // Handle attachment logic
          //          ),
          //
          //      /// TextField OR Recorder Bar
          //      if (audioController.isRecording.value)
          //        const Expanded(
          //          child: Center(
          //            child: audioController.isPause.value
          //                ? IconButton(onPressed: () => audioController.startRecording(), icon: const Icon(Iconsax.play))
          //                : IconButton(onPressed: () => audioController.pauseRecording(), icon: const Icon(Iconsax.pause)),
          //          ),
          //        ),
          //      if (!audioController.isRecording.value)
          //        const Expanded(
          //          child: TextFormField(
          //            controller: _textController,
          //            // Text editing controller
          //            style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.white),
          //            decoration: InputDecoration(
          //              hintText: 'Type a message...',
          //              fillColor: const Color(0xff1d1c21),
          //              border: InputBorder.none,
          //              hintStyle: TextStyle(color: Colors.grey[500]),
          //              errorBorder: InputBorder.none,
          //              enabledBorder: InputBorder.none,
          //              focusedBorder: InputBorder.none,
          //              disabledBorder: InputBorder.none,
          //              focusedErrorBorder: InputBorder.none,
          //            ),
          //            onChanged: (value) => value.isEmpty ? chatController.isEditing.value = false : chatController.isEditing.value = true,
          //            onFieldSubmitted: (value) {
          //              // Send the message when the user presses enter
          //              chatController.sendTextMessage(value);
          //              _textController.clear();
          //            },
          //          ),
          //        ),
          //
          //      /// Send Icon
          //
          //      // if (chatController.isEditing.value || audioController.isRecording.value)
          //      IconButton(
          //        icon: const Icon(Iconsax.send_1, color: Colors.blue),
          //        onPressed: () {
          //          if (_textController.text.isNotEmpty) {
          //            chatController.sendTextMessage(_textController.text);
          //            _textController.clear();
          //          }
          //          // if (audioController.isRecording.value) {
          //          //   audioController.stopRecording();
          //          //   audioController.isRecording.value = false;
          //          // }
          //        },
          //      ),
          //
          //      /// Mic Recording
          //      // if (!chatController.isEditing.value && !audioController.isRecording.value)
          //      //   GestureDetector(
          //      //     onTapDown: (_) => audioController.startRecording(),
          //      //     child: const Icon(Iconsax.microphone_2, color: Colors.grey),
          //      //   ),
          //    ],
          //  ),

          Row(
            children: [
              /// Attachments OR Trash
              // if (audioController.isRecording.value)
              //   IconButton(
              //     icon: const Icon(Iconsax.trash, color: Colors.red),
              //     onPressed: () => audioController.cancelRecording(),
              //   ),
              // if (!audioController.isRecording.value)
              // if (chatController.isSendingAttachment.value)
              //   const CircularProgressIndicator(color: Colors.white, strokeWidth: 1)
              // else
              //   IconButton(
              //     icon: const Icon(Iconsax.attach_circle, color: Colors.grey),
              //     //onPressed: () {}, // Handle attachment logic
              //     onPressed:  () => chatController.sendWebImageMessage(), // Handle attachment logic
              //   ),

              /// TextField OR Recorder Bar
              // if (audioController.isRecording.value)
              //   Expanded(
              //     child: Center(
              //       child: audioController.isPause.value
              //           ? IconButton(onPressed: () => audioController.startRecording(), icon: const Icon(Iconsax.play))
              //           : IconButton(onPressed: () => audioController.pauseRecording(), icon: const Icon(Iconsax.pause)),
              //     ),
              //   ),
              // if (!audioController.isRecording.value)
              Expanded(
                child: TextFormField(
                  controller: _textController,
                  // Text editing controller
                  style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: TTexts.typeAMessage.tr,
                    fillColor: const Color(0xff1d1c21),
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    errorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                  onChanged: (value) => value.isEmpty ? chatController.isEditing.value = false : chatController.isEditing.value = true,
                  onFieldSubmitted: (value) {
                    if (value.isNotEmpty) {
                      // Send the message when the user presses enter
                      chatController.sendTextMessage(value);
                      _textController.clear();
                    }
                  },
                ),
              ),

              /// Send Icon
              // if (chatController.isEditing.value || audioController.isRecording.value)
              if (chatController.isEditing.value)
                IconButton(
                  icon: const Icon(Iconsax.send_1, color: Colors.blue),
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      chatController.sendTextMessage(_textController.text);
                      _textController.clear();
                    }
                    // if (audioController.isRecording.value) {
                    //   audioController.stopRecording();
                    //   audioController.isRecording.value = false;
                    // }
                  },
                ),

              /// Mic Recording
              // if (!chatController.isEditing.value && !audioController.isRecording.value)
              //   GestureDetector(
              //     onTapDown: (_) => audioController.startRecording(),
              //     child: const Icon(Iconsax.microphone_2, color: Colors.grey),
              //   ),
            ],
          ),
        ],
      ),
    );
  }

  // Mapping ChatMessageStatus to types.Status
  types.Status mapMessageStatus(ChatMessageStatus messageStatus) {
    switch (messageStatus) {
      case ChatMessageStatus.failed:
        return types.Status.error;
      case ChatMessageStatus.read:
        return types.Status.seen;
      case ChatMessageStatus.delivered:
        return types.Status.delivered;
      case ChatMessageStatus.sent:
        return types.Status.sent;
      case ChatMessageStatus.sending:
        return types.Status.sending;
    }
  }
}
