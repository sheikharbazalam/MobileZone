import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features/personalization/models/address_model.dart';
import '../../../utils/constants/text_strings.dart';
import '../authentication/authentication_repository.dart';

class AddressRepository extends GetxController {
  // Get instance of AddressRepository using Get.find()
  static AddressRepository get instance => Get.find();

  // Firebase Firestore instance
  final _db = FirebaseFirestore.instance;

  // Fetch user addresses from Firestore based on userId
  Future<List<AddressModel>> fetchUserAddresses(String userId) async {
    try {
      // Query Firestore collection to get user addresses
      final result = await _db.collection('Users').doc(userId).collection('Addresses').get();
      // Convert Firestore document snapshots to AddressModel objects
      return result.docs.map((documentSnapshot) => AddressModel.fromDocSnapshot(documentSnapshot)).toList();
    } catch (e) {
      // Throw an error if fetching addresses fails
      throw TTexts.somethingWentWrongFetchingAddressInformation.tr;
    }
  }

  // Update the "SelectedAddress" field for a specific address
  Future<void> updateSelectedField(String addressId, bool selected) async {
    try {
      // Get the current user's ID
      final userId = AuthenticationRepository.instance.authUser!.uid;
      // Update the selected field for the specified address in Firestore
      await _db.collection('Users').doc(userId).collection('Addresses').doc(addressId).update({'SelectedAddress': selected});
    } catch (e) {
      // Throw an error if updating address selection fails
      throw TTexts.unableToUpdateYourAddressSelection.tr;
    }
  }

  // Add a new address to Firestore
  Future<String> addAddress(AddressModel address) async {
    try {
      // Get the current user's ID
      final userId = AuthenticationRepository.instance.authUser!.uid;
      // Add the address to the user's collection in Firestore
      final currentAddress = await _db.collection('Users').doc(userId).collection('Addresses').add(address.toJson());
      // Return the ID of the newly added address
      return currentAddress.id;
    } catch (e) {
      // Throw an error if adding the address fails
      throw TTexts.somethingWentWrongSavingAddressInformation.tr;
    }
  }
}
