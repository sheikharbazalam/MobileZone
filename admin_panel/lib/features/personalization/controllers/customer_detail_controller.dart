import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/user/user_repository.dart';

import '../../../data/repositories/address/address_repository.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../product_management/models/order_model.dart';
import '../models/user_model.dart';

import 'package:t_utils/t_utils.dart';

class CustomerDetailController extends GetxController {
  static CustomerDetailController get instance => Get.find();

  final UserRepository customerRepository = Get.put(UserRepository());

  RxBool ordersLoading = true.obs;
  RxBool addressesLoading = true.obs;
  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;
  RxList<bool> selectedRows = <bool>[].obs;

  final isLoading = false.obs;
  final customerId = ''.obs;
  Rx<UserModel> customer = UserModel.empty().obs;

  final addressRepository = Get.put(AddressRepository());
  final searchTextController = TextEditingController();
  RxList<OrderModel> allCustomerOrders = <OrderModel>[].obs;
  RxList<OrderModel> filteredCustomerOrders = <OrderModel>[].obs;

  /// Init Data
  Future<void> init() async {
    try {
      // Fetch record if argument was null
      if (customer.value.id.isEmpty) {
        if(customerId.isEmpty) await Get.offNamed(TRoutes.customers);

        isLoading.value = true;
        customer.value = await customerRepository.getSingleItem(customerId.value);
      }

      await getCustomerOrders();
      await getCustomerAddresses();

    } catch (e) {
      if (kDebugMode) printError(info: e.toString());
      TLoaders.errorSnackBar(title: TTexts.ohSnap.tr, message: 'Unable to fetch customer details. Try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// -- Load customer orders
  Future<void> getCustomerOrders() async {
    try {
      // Show loader while loading categories
      ordersLoading.value = true;

      // Fetch customer orders & addresses
      if (customer.value.id.isNotEmpty) {
        customer.value.orders = await UserRepository.instance.fetchUserOrders(customer.value.id);
      }

      // Update the categories list
      allCustomerOrders.assignAll(customer.value.orders ?? []);

      // Filter featured categories
      filteredCustomerOrders.assignAll(customer.value.orders ?? []);

      // Add all rows as false [Not Selected] & Toggle when required
      selectedRows.assignAll(List.generate(customer.value.orders != null ? customer.value.orders!.length : 0, (index) => false));
    } catch (e) {
      TLoaders.errorSnackBar(title: TTexts.ohSnap.tr, message: e.toString());
    } finally {
      ordersLoading.value = false;
    }
  }

  /// -- Load customer orders
  Future<void> getCustomerAddresses() async {
    try {
      // Show loader while loading categories
      addressesLoading.value = true;

      // Fetch customer orders & addresses
      if (customer.value.id.isNotEmpty) {
        customer.value.addresses = await addressRepository.fetchUserAddresses(customer.value.id);
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: TTexts.ohSnap.tr, message: e.toString());
    } finally {
      addressesLoading.value = false;
    }
  }

  /// -- Search Query Filter
  void searchQuery(String query) {
    filteredCustomerOrders.assignAll(
      allCustomerOrders.where((customer) =>
          customer.id.toLowerCase().contains(query.toLowerCase()) || customer.orderDate.toString().contains(query.toLowerCase())),
    );

    // Notify listeners about the change
    update();
  }

  /// Sorting related code
  void sortById(int sortColumnIndex, bool ascending) {
    sortAscending.value = ascending;
    filteredCustomerOrders.sort((a, b) {
      if (ascending) {
        return a.id.toLowerCase().compareTo(b.id.toLowerCase());
      } else {
        return b.id.toLowerCase().compareTo(a.id.toLowerCase());
      }
    });
    this.sortColumnIndex.value = sortColumnIndex;

    update();
  }
}
