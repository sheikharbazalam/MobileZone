import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../data/repositories/order/orders_repository.dart';
import '../../../../data/services/notification/notification_model.dart';
import '../../../../routes/routes.dart';

import '../../../../utils/constants/text_strings.dart';
import '../../../promotion_management/controllers/notification/notification_controller.dart';
import '../../models/order_activity.dart';
import '../../models/order_model.dart';
import 'order_controller.dart';

class OrderDetailController extends GetxController {
  static OrderDetailController get instance => Get.find();

  final orderId = ''.obs;
  final isLoading = false.obs;
  Rx<OrderModel> order = OrderModel.empty().obs;

  RxBool statusLoader = false.obs;
  var selectedStatus = OrderStatus.delivered.obs;
  final OrderRepository orderRepository = Get.put(OrderRepository());
  final notificationController = Get.put(NotificationController());

  /// Init Data
  Future<void> init() async {
    try {
      // Fetch record if argument was null
      if (order.value.id.isEmpty) {
        if (orderId.value.isEmpty) Get.offNamed(TRoutes.orders);

        isLoading.value = true;
        order.value = await orderRepository.getSingleItem(orderId.value);
        isLoading.value = false;
      }

      selectedStatus.value = order.value.orderStatus;
    } catch (e) {
      if (kDebugMode) printError(info: e.toString());
      TLoaders.errorSnackBar(title: TTexts.ohSnap.tr, message: TTexts.unableToFetchOrderDetails.tr,);
    }
  }

  /// Update Order Status
  Future<void> updateOrderStatus() async {
    try {
      // Start loader
      statusLoader.value = true;

      // Validate the status transition
      if (!_isValidStatusTransition(order.value.orderStatus, selectedStatus.value)) {
        TLoaders.warningSnackBar(
            title: TTexts.invalidStatus.tr, message: 'Cannot move from ${order.value.orderStatus.name} to ${selectedStatus.value.name}');
        return;
      }

      // Log activity message
      final previousStatus = order.value.orderStatus;
      final activityMessage = 'Order status changed from ${_capitalize(previousStatus.name)} to ${_capitalize(selectedStatus.value.name)}';

      // Update the order's status
      order.value.orderStatus = selectedStatus.value;

      // Determine the activity type based on the new status
      final newActivityType = _getActivityTypeForStatus(selectedStatus.value);

      // Create an activity log entry
      final activity =
          OrderActivity(activityType: newActivityType, activityDate: DateTime.now(), description: activityMessage, performedBy: 'Admin');
      order.value.activities.add(activity);

      // Add a timestamp for the last status update
      order.value.updatedAt = DateTime.now();

      // Handle specific cases, e.g., refunds
      // await _handleSpecificStatusLogic(selectedStatus.value, order.value);

      // Update the order in the database
      await orderRepository.updateItemRecord(order.value);

      // Notify user (optional: push notifications, emails, etc.)
      await _notifyUserOfStatusChange(order.value);

      // Update order in controller
      final orderController = Get.put(OrderController());
      orderController.updateItemFromLists(order.value);

      // Show success notification
      TLoaders.successSnackBar(title: TTexts.success.tr, message: TTexts.orderStatusUpdated.tr);
    } catch (e) {
      // Error handling
      TLoaders.warningSnackBar(title: TTexts.error.tr, message: e.toString());
    } finally {
      // Stop loader
      statusLoader.value = false;
    }
  }

  /// Check if the status transition is valid
  bool _isValidStatusTransition(OrderStatus currentStatus, OrderStatus newStatus) {
    final validTransitions = {
      OrderStatus.pending: [OrderStatus.processing, OrderStatus.shipped, OrderStatus.canceled],
      OrderStatus.processing: [OrderStatus.shipped, OrderStatus.canceled],
      OrderStatus.shipped: [OrderStatus.delivered, OrderStatus.refunded],
      OrderStatus.delivered: [OrderStatus.canceled],
      OrderStatus.canceled: [OrderStatus.refunded],
      OrderStatus.refunded: [],
    };

    return validTransitions[currentStatus]?.contains(newStatus) ?? false;
  }

  /// Get the activity type for a given order status
  ActivityType _getActivityTypeForStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return ActivityType.orderCreated;
      case OrderStatus.processing:
        return ActivityType.processing;
      case OrderStatus.shipped:
        return ActivityType.shipped;
      case OrderStatus.delivered:
        return ActivityType.delivered;
      case OrderStatus.canceled:
        return ActivityType.canceled;
      case OrderStatus.refunded:
        return ActivityType.returned;
      default:
        return ActivityType.canceled;
    }
  }

  /// Capitalize the first letter of a string
  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  /// Handle specific status logic, such as refunds
  Future<void> _handleSpecificStatusLogic(OrderStatus status, OrderModel order) async {
    if (status == OrderStatus.refunded) {
      // Handle refund logic (e.g., trigger refund process)
      await _processRefund(order);
    }
  }

  /// Process refund for an order
  Future<void> _processRefund(OrderModel order) async {
    // Add logic to process refund (e.g., via payment gateway API)
    // Example:
    try {
      // Assume _refundPayment is a function that handles refund via your payment gateway
      // await paymentGateway.refundPayment(order.paymentId);
      TLoaders.successSnackBar(title: 'Refunded', message: 'Order has been refunded successfully.');
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Refund Failed', message: 'Error processing the refund: $e');
    }
  }

  /// Notify the user of the order status change (optional, for notifications or emails)
  Future<void> _notifyUserOfStatusChange(OrderModel order) async {
    if (order.userDeviceToken.isEmpty) return;

    // Send push notification or email based on the status change
    // Map Data
    final newRecord = NotificationModel(
      id: '',
      title: _generateNotificationTitle(order.orderStatus),
      body: _generateNotificationMessage(order),
      senderId: AuthenticationRepository.instance.authUser?.uid ?? '',
      recipientIds: [order.userId],
      type: 'Order Update ${order.id}',
      routeId: order.docId,
      isBroadcast: true,
      route: AppRoutes.orderDetail,
      seenBy: {},
      seenAt: null,
      createdAt: DateTime.now(),
    );

    // Call Repository to Create New Notification
    newRecord.id = await notificationController.notificationRepository.addNewItem(newRecord);

    // Update All Data list
    notificationController.insertItemAtStartInLists(newRecord);
  }

  /// Generate a professional title based on the order status
  String _generateNotificationTitle(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return TTexts.orderReceivedAwaitingProcessing.tr;
      case OrderStatus.processing:
        return TTexts.orderUpdateNowProcessing.tr;
      case OrderStatus.shipped:
        return TTexts.orderShippedOnItsWay.tr;
      case OrderStatus.delivered:
        return TTexts.orderDeliveredEnjoy.tr;
      case OrderStatus.canceled:
        return TTexts.orderCanceledSorry.tr;
      case OrderStatus.refunded:
        return TTexts.refundProcessed.tr;
      default:
        return TTexts.orderUpdate.tr;
    }
  }

  /// Generate a detailed and professional message for the notification
  String _generateNotificationMessage(OrderModel order) {
    switch (order.orderStatus) {
      case OrderStatus.pending:
        return 'We have received your order #${order.id}. It is now pending and will be processed soon. Thank you for shopping with us!';
      case OrderStatus.processing:
        return 'Good news! Your order #${order.id} is now being processed. We will notify you once it’s shipped.';
      case OrderStatus.shipped:
        return 'Your order #${order.id} has been shipped! It’s on the way and will arrive soon. You can track it from your account.';
      case OrderStatus.delivered:
        return 'Your order #${order.id} has been delivered! We hope you enjoy your purchase. Feel free to leave feedback.';
      case OrderStatus.canceled:
        return 'Unfortunately, your order #${order.id} has been canceled. If you have any questions, please contact our support team.';
      case OrderStatus.refunded:
        return 'Your refund for order #${order.id} has been processed. It may take a few business days to appear in your account.';
      default:
        return 'Your order #${order.id} has been updated. Check your account for more details.';
    }
  }
}
