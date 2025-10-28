import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/notifications/notification_repository.dart';
import '../../../data/services/notifications/notification_model.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/popups/loaders.dart';

class NotificationController extends GetxController {
  static NotificationController instance = Get.find();

  final isLoading = false.obs;
  final selectedNotification = NotificationModel.empty().obs;
  final selectedNotificationId = ''.obs;

  StreamSubscription? _notificationsSubscription;
  final repository = Get.put(NotificationRepository());
  RxList<NotificationModel> notifications = RxList<NotificationModel>();

  @override
  void onInit() {
    super.onInit();
    listenToNotifications();
  }

  /// Init Data
  Future<void> init() async {
    try {
      isLoading.value = true;

      // Fetch record if argument was null
      if (selectedNotification.value.id.isEmpty) {
        if (selectedNotificationId.isEmpty) {
          Get.offNamed(TRoutes.notification);
        } else {
          selectedNotification.value = await repository.fetchSingleItem(selectedNotificationId.value);
        }
      }

      if (selectedNotification.value.id.isNotEmpty) await markNotificationAsViewed(selectedNotification.value);
    } catch (e) {
      if (kDebugMode) printError(info: e.toString());
      TLoaders.errorSnackBar(title: TTexts.ohSnap.tr, message: TTexts.unableToFetchNotification.tr);
    } finally {
      isLoading.value = false;
    }
  }

  void listenToNotifications() {
    _notificationsSubscription = repository.fetchAllItemsAsStream().listen(
      (notificationList) {
        notifications.value = notificationList; // Update the notifications list in real-time
      },
      onError: (error) {
        TLoaders.warningSnackBar(
          title: TTexts.error.tr,
          message: TTexts.failToFetchNotification.trParams({'error': error.toString()}),
        );
      },
    );
  }

  Future<void> fetchNotifications() async {
    try {
      final result = await repository.fetchAllItems();
      notifications.value = result;
    } catch (e) {
      TLoaders.warningSnackBar(title: TTexts.error.tr, message: '${TTexts.failToFetchNotification.tr} $e');
    }
  }

  Future<void> markNotificationAsViewed(NotificationModel notification) async {
    try {
      final String notificationId = notification.id;
      final String currentUserId = AuthenticationRepository.instance.getUserID;

      if (notification.seenBy.isEmpty || notification.seenBy[currentUserId] == false) {
        await repository.markNotificationAsSeen(notificationId, currentUserId);

        notifications.firstWhere((n) => n.id == notification.id).seenBy[currentUserId] = true;
        notifications.refresh();
      }
    } catch (e) {
      TLoaders.warningSnackBar(title: TTexts.error.tr, message: '${TTexts.markNotificationAsSeen.tr} $e');
    }
  }

  @override
  void onClose() {
    _notificationsSubscription?.cancel(); // Cancel the subscription when the widget is destroyed
    super.onClose();
  }
}
