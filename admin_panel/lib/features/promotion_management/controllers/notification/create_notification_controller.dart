import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/notification/notifications_repository.dart';
import '../../../../data/services/notification/notification_model.dart';
import '../../../../routes/routes.dart';

import '../../../../utils/constants/text_strings.dart';
import '../../../personalization/controllers/user_controller.dart';
import 'notification_controller.dart';

import 'package:t_utils/t_utils.dart';

class CreateNotificationController extends GetxController {
  static CreateNotificationController get instance => Get.find();

  final isLoading = false.obs;

  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final description = TextEditingController();

  // Add a recipient Ids or send to all User and Retailers

  final notificationController = Get.put(NotificationController());
  final repository = Get.put(NotificationRepository());

  /// Register new Notification
  Future<void> createNotification() async {
    try {
      // Start Loading
      isLoading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      final userController = Get.put(UserController());

      final users = await userController.userRepository.getAllItems();

      // Map Data
      final newRecord = NotificationModel(
        id: '',
        title: title.text.trim(),
        body: description.text.trim(),
        senderId: userController.user.value.id,
        recipientIds: users.map((user) => user.id).toList(),
        type: 'Promotion',
        routeId: '',
        isBroadcast: true,
        route: AppRoutes.notificationDetails,
        seenBy: {},
        seenAt: null,
        createdAt: DateTime.now(),
      );

      // Call Repository to Create New Notification
      newRecord.id = await repository.addNewItem(newRecord);

      // Update All Data list
      notificationController.insertItemAtStartInLists(newRecord);

      // Reset Form
      resetFields();

      // Remove Loader
      isLoading.value = false;

      // Return
      Get.back();

      // Success Message & Redirect
      TLoaders.successSnackBar(title: TTexts.congratulations.tr, message: TTexts.newRecordAdded.tr);
    } catch (e) {
      isLoading.value = false;
      TLoaders.errorSnackBar(title:TTexts.ohSnap.tr, message: e.toString());
    }
  }

  /// Method to reset fields
  void resetFields() {
    title.clear();
    description.clear();
    isLoading(false);
  }
}
