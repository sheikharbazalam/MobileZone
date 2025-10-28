import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:t_utils/t_utils.dart';


class NotificationService extends GetxController {
  static NotificationService get instance => Get.find();

  /// Send Notification
  Future<void> sendNotification(
      {required String title, required String body, required String deviceToken, required String route, required String id}) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendNotification');
      await callable.call({
        'title': title,
        'body': body,
        'deviceToken': deviceToken,
        'route': route,
        'id': id,
      });
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
