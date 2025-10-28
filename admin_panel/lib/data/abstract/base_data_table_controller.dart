import 'package:cwt_ecommerce_admin_panel/features/personalization/controllers/user_controller.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_overlay_notification/t_overlay_notification.dart';
import 'package:t_utils/t_utils.dart';

/// A generic controller class for managing data tables using GetX state management.
/// This class provides common functionalities for handling data tables, including fetching, updating, and deleting items.
abstract class TBaseTableController<T> extends GetxController {
  RxInt limit = 10.obs;
  RxBool isLoading = false.obs;
  RxBool allItemsFetched = false.obs;
  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;
  RxList<T> allItems = <T>[].obs;
  RxList<T> filteredItems = <T>[].obs;
  RxList<bool> selectedRows = <bool>[].obs;
  RxList<bool> statusToggleSwitchLoaders = <bool>[].obs;
  RxList<bool> featuredToggleSwitchLoaders = <bool>[].obs;
  final searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  /// Abstract method to be implemented by subclasses for fetching items.
  Future<List<T>> fetchItems();

  /// Abstract method to be implemented by subclasses for fetching items.
  Future<T?> updateStatusToggleSwitch(bool toggle, T item);

  Future<T?> updateFeaturedToggleSwitch(bool toggle, T item);

  /// Abstract method to be implemented by subclasses for deleting an item.
  Future<void> deleteItem(T item);

  /// Abstract method to be implemented by subclasses for checking if an item contains the search query.
  bool containsSearchQuery(T item, String query);

  /// Common method for fetching data.
  Future<void> fetchData() async {
    try {
      isLoading.value = true; // Set loading state to true

      // Fetch paginated items for the current page
      List<T> fetchedItems = await fetchItems();
      if (fetchedItems.isEmpty) {
        allItemsFetched.value = true;
      } else {
        if (fetchedItems.length < limit.value) {
          allItemsFetched.value = true;
        } else {
          allItemsFetched.value = false;
        }
        // Append the fetched items to the existing list
        allItems.addAll(fetchedItems);
        filteredItems.assignAll(allItems);
        selectedRows.assignAll(List.generate(allItems.length, (index) => false));
        statusToggleSwitchLoaders.assignAll(List.generate(allItems.length, (index) => false));
        featuredToggleSwitchLoaders.assignAll(List.generate(allItems.length, (index) => false));
      }
    } catch (e) {
      allItemsFetched.value = false;
      TNotificationOverlay.error(context: Get.context!, title: 'Record not found', subTitle: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Common method for searching based on a query
  void searchQuery(String query) {
    filteredItems.assignAll(
      allItems.where((item) => containsSearchQuery(item, query)),
    );
  }

  /// Common method for sorting items by a property
  void sortByProperty(int sortColumnIndex, bool ascending, Function(T) property) {
    sortAscending.value = ascending;
    filteredItems.sort((a, b) {
      if (ascending) {
        return property(a).compareTo(property(b));
      } else {
        return property(b).compareTo(property(a));
      }
    });
    this.sortColumnIndex.value = sortColumnIndex;
  }

  void featuredToggleSwitch({required int index, required bool toggle, required T item}) async {
    try {
      featuredToggleSwitchLoaders[index] = true;
      T? result = await updateFeaturedToggleSwitch(toggle, item);
      if (result != null) updateItemFromLists(result);
    } catch (e) {
      TNotificationOverlay.error(context: Get.context!, title: 'Unable to Switch', subTitle: e.toString());
    } finally {
      featuredToggleSwitchLoaders[index] = false;
    }
  }

  void statusToggleSwitch({required int index, required bool toggle, required T item}) async {
    try {
      statusToggleSwitchLoaders[index] = true;
      T? result = await updateStatusToggleSwitch(toggle, item);
      if (result != null) updateItemFromLists(result);
    } catch (e) {
      TNotificationOverlay.error(context: Get.context!, title: 'Unable to Switch', subTitle: e.toString());
    } finally {
      statusToggleSwitchLoaders[index] = false;
    }
  }

  /// Method for adding an item to the lists.
  void insertItemAtStartInLists(T item) {
    try {
      allItems.insert(0, item);
      filteredItems.insert(0, item);
      selectedRows.assignAll(List.generate(allItems.length, (index) => false));
      statusToggleSwitchLoaders.assignAll(List.generate(allItems.length, (index) => false));
      featuredToggleSwitchLoaders.assignAll(List.generate(allItems.length, (index) => false));
      filteredItems.refresh(); // Refresh the UI to reflect the changes
    } catch (e) {
      rethrow;
    }
  }

  /// Method for adding an item to the lists.
  void addItemToLists(T item) {
    allItems.add(item);
    filteredItems.add(item);
    selectedRows.assignAll(List.generate(allItems.length, (index) => false));
    statusToggleSwitchLoaders.assignAll(List.generate(allItems.length, (index) => false));
    featuredToggleSwitchLoaders.assignAll(List.generate(allItems.length, (index) => false));
    filteredItems.refresh(); // Refresh the UI to reflect the changes
  }

  /// Method for updating an item in the lists.
  void updateItemFromLists(T item) {
    final itemIndex = allItems.indexWhere((i) => i == item);
    final filteredItemIndex = filteredItems.indexWhere((i) => i == item);

    if (itemIndex != -1) allItems[itemIndex] = item;
    if (filteredItemIndex != -1) filteredItems[itemIndex] = item;

    filteredItems.refresh(); // Refresh the UI to reflect the changes
  }

  /// Method for removing an item from the lists.
  void removeItemFromLists(T item) {
    allItems.remove(item);
    filteredItems.remove(item);
    selectedRows.assignAll(List.generate(allItems.length, (index) => false));
    statusToggleSwitchLoaders.assignAll(List.generate(allItems.length, (index) => false));
    featuredToggleSwitchLoaders.assignAll(List.generate(allItems.length, (index) => false));

    filteredItems.refresh();
  }

  /// Common method for confirming deletion and performing the deletion.
  Future<void> confirmAndDeleteItem(T item) async {
    // Show a confirmation dialog
    TDialogs.defaultDialog(
      context: Get.context!,
      confirmText: 'Delete',
      onConfirm: () async => deleteOnConfirm(item),
      content: const Text('Are you sure you want to delete this item?'),
    );
  }

  /// Method to be implemented by subclasses for handling confirmation before deleting an item.
  void deleteOnConfirm(T item) async {
    try {
      // Remove the Confirmation Dialog
      TFullScreenLoader.stopLoading();

      // Start the loader
      TFullScreenLoader.popUpCircular();

      if (UserController.instance.user.value.role != AppRole.superAdmin) {
        throw 'You are not authorized to delete this item.';
      }

      // Delete Firestore Data
      await deleteItem(item);

      removeItemFromLists(item);

      update();

      TFullScreenLoader.stopLoading();
      TNotificationOverlay.success(context: Get.context!, title: 'Item Deleted', subTitle: 'Your Item has been Deleted');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TNotificationOverlay.error(context: Get.context!, title: 'Item not deleted', subTitle: e.toString());
    }
  }
}
