import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:t_utils/utils/constants/enums.dart';

import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../data/repositories/order/order_repository.dart';
import '../../../../data/services/notifications/notification_service.dart';
import '../../../../data/services/stripe/stripe_service.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../personalization/controllers/address_controller.dart';
import '../../../personalization/controllers/settings_controller.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../models/coupon_model.dart';
import '../../models/order_activity.dart';
import '../../models/order_model.dart';
import '../../models/shipping_model.dart';
import '../coupon_controller.dart';
import 'cart_controller.dart';
import 'checkout_controller.dart';
import 'product_controller.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  // Order Details Values

  final isLoading = false.obs;
  final loadingOrders = false.obs;
  Rx<OrderModel> selectedOrder = OrderModel.empty().obs;
  final selectedOrderId = ''.obs;

  /// Variables
  var selectedMethod = 0.obs;
  final orders = <OrderModel>[].obs;

  final cartController = CartController.instance;
  final addressController = AddressController.instance;
  final checkoutController = Get.put(CheckoutController());
  final couponController = Get.put(CouponController());
  final orderRepository = Get.put(OrderRepository());
  final userController = Get.put(UserController());
  final settingController = Get.put(SettingsController());

  @override
  void onInit() {
    super.onInit();
    fetchUserOrders();
  }

  /// Init Data
  Future<void> init() async {
    try {
      isLoading.value = true;
      // Fetch record if argument was null
      if (selectedOrder.value.id.isEmpty) {
        if (selectedOrderId.value.isEmpty) {
          Get.back();
        } else {
          selectedOrder.value = await orderRepository.fetchSingleItem(selectedOrderId.value);

          if (selectedOrder.value.id.isEmpty) Get.back();
        }
      }
    } catch (e) {
      if (selectedOrder.value.id.isEmpty) {
        Get.back();
      } else {
        TLoaders.errorSnackBar(title: TTexts.ohSnap.tr, message: '${TTexts.unableFetchOrderDetail.tr} $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void selectMethod(int index) {
    selectedMethod.value = index;
  }

  /// Fetch user's order history
  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      loadingOrders.value = true;
      final userOrders = await orderRepository.fetchAllItems();
      orders.addAll(userOrders);
      return userOrders;
    } catch (e) {
      TLoaders.warningSnackBar(title: TTexts.ohSnap.tr, message: e.toString());
      return [];
    } finally {
      loadingOrders.value = false;
    }
  }

  Future<OrderModel> fetchSingleOrder(String id) async {
    return await orderRepository.fetchSingleItem(id);
  }

  /// Method for order processing
  void processOrder(double subTotal) async {
    try {
      if (addressController.selectedAddress.value.id.isEmpty) {
        TLoaders.warningSnackBar(title: TTexts.addressRequired.tr, message: TTexts.addressRequiredMessage.tr);
        return;
      }

      if (userController.user.value.id.isEmpty) return;

      if (addressController.billingSameAsShipping.isFalse) {
        if (addressController.selectedBillingAddress.value.id.isEmpty) {
          TLoaders.warningSnackBar(title: TTexts.billingAddressRequired.tr, message: TTexts.billingAddressRequiredMessage.tr);
          return;
        }
      }

      // Start Loader
      TFullScreenLoader.openLoadingDialog( TTexts.processingYourOrder.tr, TImages.pencilAnimation);

      // Get User Token
      final token = await TNotificationService.getToken();

      final shipping = ShippingInfo(
        carrier: '',
        trackingNumber: UniqueKey().toString(),
        shippingStatus: ShippingStatus.pending,
        shippingMethod: ShippingMethod.express,
      );

      final activity = OrderActivity(
        activityType: ActivityType.orderCreated,
        activityDate: DateTime.now(),
        performedBy: Role.user.name,
        description:  TTexts.orderCreateSuccessfully.tr,
      );

      final totalAmount = double.parse(checkoutController.calculateGrandTotal(subTotal).toStringAsFixed(2));
      final shippingAmount =
          SettingsController.instance.settings.value.isTaxShippingEnabled
              ? checkoutController.getShippingCost(
                (subTotal - checkoutController.calculateTotalDiscount(subTotal)).clamp(0.0, double.infinity),
              )
              : 0.0;
      final taxAmount = SettingsController.instance.settings.value.isTaxShippingEnabled ? checkoutController.getTaxAmount(subTotal) : 0.0;
      final pointsUsed = checkoutController.isUsingPoints.value ? checkoutController.pointsDiscountAmount.value.toInt() : 0;
      final couponDiscountAmount = couponController.coupon.value.discountType == DiscountType.flat ? couponController.coupon.value.discountValue : ((couponController.coupon.value.discountValue * subTotal) / 100);
      // Add Details
      final order = OrderModel(
        docId: '',
        id: UniqueKey().toString(),
        userId: userController.user.value.id,
        userName: userController.user.value.fullName,
        userEmail: userController.user.value.email,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        shippingAddress: addressController.selectedAddress.value,
        products: cartController.cartItems,
        paymentStatus: PaymentStatus.unpaid,
        orderStatus: OrderStatus.pending,
        shippingInfo: shipping,
        activities: [activity],
        itemCount: cartController.cartItems.length,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        shippingAmount: shippingAmount,
        taxAmount: taxAmount,
        billingAddress: null,
        billingAddressSameAsShipping: true,
        userDeviceToken: token,
        subTotal: subTotal,
        coupon: couponController.coupon.value,
        taxRate: settingController.settings.value.taxRate,
        couponDiscountAmount: couponDiscountAmount,
        pointsUsed: pointsUsed,
        pointsDiscountAmount: checkoutController.pointsDiscountAmount.value,
        totalDiscountAmount: checkoutController.calculateTotalDiscount(subTotal),
        paymentMethodType: checkoutController.selectedPaymentMethod.value.paymentMethod,
      );

      // Save the order to Firestore
      order.docId = await orderRepository.addItem(order);

      // Process Payment
      if (checkoutController.selectedPaymentMethod.value.paymentMethod == PaymentMethods.card ||
          checkoutController.selectedPaymentMethod.value.paymentMethod == PaymentMethods.paypal) {
        await processStripePayment(order);
      }

      // Update coupon count if applied
      if (couponController.coupon.value.id.isNotEmpty) {
        couponController.updateUsageCount(couponController.coupon.value);
      }

      // Update user order count
      await userController.updateUserAfterOrder(total: totalAmount, isUsingPoints: checkoutController.isUsingPoints.value);

      // Once the order placed, update Stock of each item
      final productController = Get.put(ProductController());

      for (var product in cartController.cartItems) {
        await productController.updateProductStock(product.productId, product.quantity, product.variationId);
      }

      // Update the cart status
      cartController.clearCart();

      // Update Coupon
      couponController.coupon.value = CouponModel.empty();

      // Update orders list
      orders.add(order);

      // Create and add the notification using the existing `addNotification` method
      addNotification(order);

      // Show Success screen
      Get.off(
        () => SuccessScreen(
          image: TImages.orderCompletedAnimation,
          title: TTexts.orderSuccess.tr,
          subTitle: TTexts.orderSuccessSubTitle.tr,
          onPressed: () => Get.offAllNamed(TRoutes.homeMenu),
        ),
      );
    } on StripeException catch (e) {
      TFullScreenLoader.stopLoading();
      final code = e.error.code;
      final message = e.error.localizedMessage;
      TLoaders.errorSnackBar(title: 'Stripe: $code', message: message);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title:TTexts.ohSnap.tr, message: e.toString());
    }
  }

  void addNotification(OrderModel order) {
    TNotificationService.instance.addNotification(
      RemoteMessage(
        messageId: UniqueKey().toString(),
        notification: RemoteNotification(
          title:TTexts.orderPlacedSuccess.tr,
          body: 'Your order #${order.id} has been successfully placed. We\'ll notify you once it\'s shipped.',
        ),
        data: {'route': TRoutes.orderDetail, 'id': order.id},
      ),
      route: "${TRoutes.orderDetail}/${order.id}",
      routeId: order.id,
    );
  }

  /// Method for cancelling order
  Future<void> cancelOrder(OrderModel order) async {
    await orderRepository.updateSingleField(order.id, {'orderStatus': OrderStatus.canceled.name, 'updatedAt': DateTime.now()});
    TLoaders.successSnackBar(title: TTexts.ohSnap.tr, message: TTexts.orderCancelled.tr);
    selectedOrder.refresh();
  }

  /// Method for processing payment
  Future<void> processStripePayment(OrderModel order) async {
      final paymentResult = await TStripePaymentService.instance.processPayment(
        amount: order.totalAmount,
        currency: 'usd',
        orderId: order.docId,
      );

      if (paymentResult['paymentStatus'] == 'Succeeded') {
        await _updateOrderWithPaymentDetails(order.docId, paymentResult);
      } else {
        _handlePaymentFailure(order.docId, paymentResult);
      }
  }

  /// Method for updating order with payment details
  Future<void> _updateOrderWithPaymentDetails(String orderId, Map<String, dynamic> details) async {
    final updatedOrder = {
      'paymentIntentId': details['paymentIntentId'],
      'paymentMethodId': details['paymentMethodId'],
      'amountCaptured': details['amountCaptured'],
      'currency': details['currency'],
      'paymentMethod': details['paymentMethod'],
      'paymentStatus': PaymentStatus.paid.name,
      'updatedAt': DateTime.now(),
    };

    // Update Firestore and local state
    await OrderRepository.instance.updateSingleField(orderId, updatedOrder);
  }

  /// Method for handling payment failure
  Future<void> _handlePaymentFailure(String orderId, Map<String, dynamic>? errorDetails) async {
    final updatedOrder = {
      'paymentStatus': PaymentStatus.failed.name,
      'lastPaymentError': errorDetails?['errorMessage'],
      'paymentErrorCode': errorDetails?['errorCode'],
      'updatedAt': DateTime.now(),
    };

    await OrderRepository.instance.updateSingleField(orderId, updatedOrder);

    TLoaders.errorSnackBar(title: TTexts.paymentFailed.tr, message: errorDetails?['errorMessage'] ?? 'Unknown error');
  }
}
