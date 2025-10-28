import 'package:get/get.dart';

import 'package:t_utils/t_utils.dart';

import '../../../data/repositories/stats/order_stats_by_status_repository.dart';
import '../../../data/repositories/stats/order_stats_repository.dart';
import '../../../utils/constants/text_strings.dart';
import '../../product_management/controllers/order/order_controller.dart';
import '../models/order_stats_by_status_model.dart.dart';
import '../models/order_stats_model.dart';

class DashboardController extends GetxController {
  // Singleton instance
  static DashboardController get instance => Get.find<DashboardController>();

  // Injected dependencies
  final OrderController orderController = Get.put(OrderController());
  final OrderStatsRepository orderStatsRepository = Get.put(OrderStatsRepository());
  final OrderStatsByStatusRepository orderStatsByStatusRepository = Get.put(OrderStatsByStatusRepository());

  // Reactive fields
  final RxMap<OrderStatus, int> orderStatusData = <OrderStatus, int>{}.obs;
  final RxMap<OrderStatus, double> totalAmounts = <OrderStatus, double>{}.obs;

  // Stats for various time periods
  final Rx<OrderStatsModel> recentYearStats = OrderStatsModel.empty().obs;
  final Rx<OrderStatsModel> lastYearStats = OrderStatsModel.empty().obs;
  final Rx<OrderStatsModel> recentMonthStats = OrderStatsModel.empty().obs;
  final Rx<OrderStatsModel> lastMonthStats = OrderStatsModel.empty().obs;
  final Rx<OrderStatsModel> weeklyStats = OrderStatsModel.empty().obs;

  final Rx<OrderStatsByStatusModel> orderStatusStat = OrderStatsByStatusModel.empty().obs;

  // Weekly sales data
  final RxList<double> weeklySales = List<double>.filled(7, 0.0).obs;

  // Percentages
  final Rx<double> revenuePercentage = 0.0.obs;
  final Rx<double> averagePercentage = 0.0.obs;
  final Rx<double> ordersPercentage = 0.0.obs;
  final Rx<double> soldProductsPercentage = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchInitialStats();
  }

  /// Fetch all required stats
  Future<void> _fetchInitialStats() async {
    final today = DateTime.now();

    try {
      await Future.wait([
        _fetchYearlyStats(today),
        _fetchMonthlyStats(today),
        _fetchWeeklyStats(today),
        // Calculate order status data
        _fetchOrderStats(),
        if (orderController.allItems.isEmpty) orderController.fetchItems(),
      ]);

      // Calculate all percentages
      _calculateAllPercentages();
    } catch (e) {
      print('Error fetching stats: $e');
    }
  }

  Future<void> _fetchOrderStats() async {
    final results = await Future.wait([orderStatsByStatusRepository.getSingleItem("status")]);
    orderStatusStat.value = results[0];
  }

  /// Fetch yearly stats
  Future<void> _fetchYearlyStats(DateTime today) async {
    final lastYearDate = DateTime(today.year - 1, today.month, today.day);
    final results = await Future.wait([
      orderStatsRepository.getSingleItem(TStatsHelper.yearlyKey(today)),
      orderStatsRepository.getSingleItem(TStatsHelper.yearlyKey(lastYearDate)),
    ]);
    recentYearStats.value = results[0];
    lastYearStats.value = results[1];
  }

  /// Fetch monthly stats
  Future<void> _fetchMonthlyStats(DateTime today) async {
    final lastMonthDate = DateTime(today.year, today.month - 1, today.day);
    final results = await Future.wait([
      orderStatsRepository.getSingleItem(TStatsHelper.monthlyKey(today)),
      orderStatsRepository.getSingleItem(TStatsHelper.monthlyKey(lastMonthDate)),
    ]);
    recentMonthStats.value = results[0];
    lastMonthStats.value = results[1];
  }

  /// Fetch weekly stats
  Future<void> _fetchWeeklyStats(DateTime today) async {
    weeklySales.clear();
    final fetches = List.generate(7, (i) {
      final day = today.subtract(Duration(days: i));
      return orderStatsRepository.getSingleItem(TStatsHelper.dailyKey(day));
    });

    final results = await Future.wait(fetches);
    weeklySales.value = results.map((stats) => stats.totalRevenue).toList().reversed.toList();
  }

  /// Calculate all key percentage metrics
  void _calculateAllPercentages() {
    revenuePercentage.value = _calculatePercentage(
      recentYearStats.value.totalRevenue,
      lastYearStats.value.totalRevenue,
    );

    averagePercentage.value = _calculateAveragePercentage();
    ordersPercentage.value = _calculatePercentage(
      recentYearStats.value.totalOrders,
      lastYearStats.value.totalOrders,
    );

    soldProductsPercentage.value = _calculatePercentage(
      recentYearStats.value.totalItemsSold,
      lastYearStats.value.totalItemsSold,
    );
  }

  /// Calculate average percentage change compared to last month
  double _calculateAveragePercentage() {
    final currentAvg =
        recentYearStats.value.totalRevenue / (recentYearStats.value.totalOrders == 0 ? 1 : recentYearStats.value.totalOrders);
    final lastAvg = lastYearStats.value.totalRevenue / (lastYearStats.value.totalOrders == 0 ? 1 : lastYearStats.value.totalOrders);

    return _calculatePercentage(currentAvg, lastAvg);
  }

  /// Generalized percentage calculation
  double _calculatePercentage(var current, var previous) {
    if (current == 0 && previous == 0) return 0.0; // No sales in both years
    if (previous == 0) return 100.0; // If no sales last year but there are sales now, it's considered 100% increase

    return ((current - previous) / previous) * 100;
  }

  /// Get order count based on status
  int getOrderCount(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return orderStatusStat.value.pending;
      case OrderStatus.processing:
        return orderStatusStat.value.processing;
      case OrderStatus.shipped:
        return orderStatusStat.value.shipped;
      case OrderStatus.delivered:
        return orderStatusStat.value.delivered;
      case OrderStatus.canceled:
        return orderStatusStat.value.canceled;
      case OrderStatus.returned:
        return orderStatusStat.value.returned;
      case OrderStatus.refunded:
        return orderStatusStat.value.refunded;
    }
  }

  /// Get total orders across all statuses
  int getTotalOrders() {
    return orderStatusStat.value.pending +
        orderStatusStat.value.processing +
        orderStatusStat.value.shipped +
        orderStatusStat.value.delivered +
        orderStatusStat.value.canceled +
        orderStatusStat.value.returned +
        orderStatusStat.value.refunded;
  }

  // Display-friendly name for order status
  String getDisplayStatusName(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return TTexts.pending.tr;
      case OrderStatus.processing:
        return TTexts.processing.tr;
      case OrderStatus.shipped:
        return TTexts.shipped.tr;
      case OrderStatus.delivered:
        return TTexts.delivered.tr;
      case OrderStatus.canceled:
        return TTexts.cancelled.tr;
      case OrderStatus.returned:
        return TTexts.returned.tr;
      case OrderStatus.refunded:
        return TTexts.refunded.tr;
    }
  }
}
