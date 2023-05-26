import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  final isLoading = false.obs;
  final isOffline = false.obs;
  late StreamSubscription subscription;

  @override
  void onInit() {
    super.onInit();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      isOffline(result == ConnectivityResult.none);
    });
  }

  @override
  void onClose() {
    subscription.cancel();
    super.onClose();
  }
}
