import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:t_utils/utils/popups/loaders.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/chat/chat_repository.dart';
import '../../../data/services/cloud_storage/firebase_storage_service.dart';
import '../../../utils/exports.dart';
import '../../personalization/controllers/user_controller.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/participant_model.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find();
  final ChatRepository _chatRepository = Get.put(ChatRepository());

  // Observables
  var chats = <ChatModel>[].obs;
  var messages = <MessageModel>[].obs;
  var isEditing = false.obs;
  var isLoading = false.obs;
  var isSendingAttachment = false.obs;
  var currentChatId = ''.obs;
  var currentChat = ChatModel.empty().obs;
  var selectedChat = Rxn<ChatModel>();

  @override
  void onInit() {
    super.onInit();
    fetchUserChats();
    // listenToAllChats();
  }

  Future<void> fetchUserChats() async {
    try {
      chats.clear();
      currentChatId.value = '';
      isLoading.value = true;
      currentChat.value = ChatModel.empty();
      List<ChatModel> userChats = await _chatRepository.getChatsByTypeOnly(ChatType.support);
      chats.assignAll(userChats);
    } finally {
      isLoading.value = false;
    }
  }

  // Method to Listen messages of All Chats
  void listenToAllChats() {
    _chatRepository.listenToAllChats(ChatType.support).listen((updatedChats) {
      chats.assignAll(updatedChats);
    });
  }

  //Fetch messages for a specific chat
  Future<void> fetchMessages() async {
    try {
      // Fetch Chats if empty
      if (currentChat.value.id.isEmpty) {
        final chat = await _chatRepository.getChatById(currentChatId.value);
        currentChat.value = chat;
      }
      isLoading.value = true;

      // Fetch Message
      _chatRepository.listenToMessages(currentChatId.value).listen((newMessages) {
        if (newMessages.isNotEmpty) {
          // Ensure messages belong to the currently selected chat
          // if (currentChat.value.participantIds.contains(newMessages.first.senderId)) {
          messages.value = List<MessageModel>.from(newMessages);

          // Mark messages as seen
          markMessagesAsSeen();

          // Update the last message in the selected chat
          final updatedChat = ChatController.instance.chats.firstWhere(
                (chat) => chat.id == currentChat.value.id,
            orElse: () => ChatModel.empty(),
          );

          if (updatedChat.id.isNotEmpty) {
            updatedChat.lastMessage = newMessages.first.content;
            updatedChat.lastMessageType = newMessages.first.type;
            updatedChat.lastMessageTime = newMessages.first.timestamp;
            updatedChat.lastMessageStatus = newMessages.first.status;
            updatedChat.lastMessageSenderId = newMessages.first.senderId;

            // Find the chat index and update it
            int chatIndex = ChatController.instance.chats.indexWhere((chat) => chat.id == updatedChat.id);
            if (chatIndex != -1) {
              ChatController.instance.chats[chatIndex] = updatedChat;
            }
          }
        // }
        }
      });
    } catch (e) {
      TLoaders.errorSnackBar(title: TTexts.ohSnap.tr, message: TTexts.unexpectedError.tr);
    } finally {
      isLoading.value = false;
    }
  }

  // Method to mark messages as seen
  void markMessagesAsSeen() async {
    final currentUserId = UserController.instance.user.value.id; // Replace with the actual user ID
    await _chatRepository.markMessagesAsSeen(currentChatId.value, currentUserId);
  }

  // Create a new chat or fetch the existing one
  Future<void> createChat({required ParticipantModel receiver, required ChatType chatType}) async {
    try {
      isLoading.value = true;
      List<ParticipantModel> participants = [
        ParticipantModel(
          userId: UserController.instance.user.value.id,
          name: UserController.instance.user.value.fullName,
          profileImageURL: UserController.instance.user.value.profilePicture,
        ),
        receiver,
      ];

      final chat = ChatModel(
        id: '',
        participants: participants,
        lastMessageTime: DateTime.now(),
        chatType: chatType,
        participantIds: participants.map((p) => p.userId).toList(),
        referenceId: "",
      );

      ChatModel? receivedChat = await _chatRepository.createChat(chat);
      if (receivedChat != null) currentChat.value = receivedChat;
      if (receivedChat != null) chats.add(receivedChat);
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch chats based on type with Admin (support)
  Future<void> fetchChatsByType(String currentUserId, ChatType chatType) async {
    try {
      isLoading.value = true;
      List<ChatModel> typedChats = await _chatRepository.getChatsByType(currentUserId, chatType);
      chats.assignAll(typedChats);
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch chats based on type (ride,)
  Future<void> fetchChatsByTypeOnly(ChatType chatType) async {
    try {
      isLoading.value = true;
      List<ChatModel> typedChats = await _chatRepository.getChatsByTypeOnly(chatType);
      chats.assignAll(typedChats);
    } finally {
      isLoading.value = false;
    }
  }

  // Mark the chat as read
  Future<void> markChatAsRead(String chatId) async {
    await _chatRepository.markChatAsRead(chatId);
  }

  // Send a text message
  Future<void> sendTextMessage(String content) async {
    _sendMessage(content, MessageType.text);
  }

  // Send an image message
  Future<void> sendImageMessage(File imagePath) async {
    try {
      isSendingAttachment.value = true;
      // Close the Bottom Sheet
      Get.back();

      // Upload image to Firebase Storage
      final url = await TFirebaseStorageService.instance
          .uploadImageFile('Chats/${currentChatId.value}', imagePath as XFile, const UuidV4().generate());
      await _sendMessage(url, MessageType.image);
    } catch (e) {
      TLoaders.warningSnackBar(title: TTexts.ohSnap.tr, message: TTexts.failedToSendMessagePleaseTryAgain.tr);
    } finally {
      isSendingAttachment.value = false;
    }
  }

  /// Sends an image message by uploading the selected image to Firebase Storage.
  Future<void> sendWebImageMessage() async {
    try {
      isSendingAttachment.value = true;

      // Open file picker and get the image as bytes
      Uint8List? imageBytes = await ImagePickerWeb.getImageAsBytes();
      if (imageBytes != null) {
        // Close the Bottom Sheet
        Get.back();

        // Generate a unique file name
        String fileName = const Uuid().v4();

        // Upload image to Firebase Storage
        final url = await TFirebaseStorageService.instance.uploadImageData(
          'Chats/${currentChatId.value}',
          imageBytes,
          fileName,
        );

        // Send the image message
        await _sendMessage(url, MessageType.image);
      } else {
        Get.snackbar(TTexts.noImageSelected.tr,
            TTexts.pleaseSelectAnImageToSend.tr);
      }
    } catch (e) {
      Get.snackbar(TTexts.ohSnap.tr, TTexts.unableToSendImage.tr);
    } finally {
      isSendingAttachment.value = false;
    }
  }

  // Generic function to send a message of any type
  Future<void> _sendMessage(String content, MessageType messageType) async {
    // 1. Create a new audio message with 'sending' status
    MessageModel newMessage = MessageModel(
      id: '',
      senderId: AuthenticationRepository.instance.authUser!.uid,
      content: content,
      timestamp: DateTime.now(),
      status: ChatMessageStatus.sent,
      type: messageType,
    );

    // Add message locally so it appears instantly
    messages.insert(0, newMessage);

    // Update Chat Last Message
    updateChatLastMessage(newMessage);

    isEditing.value = false;
    try {
      // Send the message to Firestore with 'sending' status
      final messageId = await _chatRepository.sendMessage(currentChat.value.id, newMessage);

      // 7. Update the message ID locally once it's saved in Firestore
      if (messageId.isNotEmpty) {
        newMessage.id = messageId;

        // 8. Find the index of the message in the local list using the temporary ID
        int messageIndex = ChatController.instance.messages.indexWhere((msg) => msg.id == messageId);

        if (messageIndex != -1) {
          // Update the message in the list with the new ID
          ChatController.instance.messages[messageIndex] = newMessage;
        }

        // 5. Update the last message in the selected chat
        final updatedChat = ChatController.instance.chats.firstWhere(
          (chat) => chat.id == currentChat.value.id,
          orElse: () => ChatModel.empty(),
        );

        updatedChat.lastMessage = newMessage.content;
        updatedChat.lastMessageType = messageType;
        updatedChat.lastMessageTime = DateTime.now();
        updatedChat.lastMessageStatus = ChatMessageStatus.sent;
        updatedChat.lastMessageSenderId = AuthenticationRepository.instance.authUser!.uid;

        // Update the selected chat in the chat list
        int chatIndex = ChatController.instance.chats.indexWhere((chat) => chat.id == updatedChat.id);
        if (chatIndex != -1) {
          ChatController.instance.chats[chatIndex] = updatedChat;
        }
      }

      refresh();
    } catch (e) {
      messages[0].status = ChatMessageStatus.failed;
      TLoaders.warningSnackBar(title: TTexts.ohSnap.tr,
        message: TTexts.failedToSendMessagePleaseTryAgain.tr,);
    }
  }

  void updateChatLastMessage(MessageModel message) {
    currentChat.value.lastMessage = message.content;
    currentChat.value.lastMessageType = message.type;
    currentChat.value.lastMessageStatus = message.status;
    currentChat.value.lastMessageTime = message.timestamp;
    currentChat.value.lastMessageSenderId = message.senderId;
  }

  void selectChat(ChatModel chat) {
    selectedChat.value = chat;
  }

}
