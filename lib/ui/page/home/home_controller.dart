import 'dart:async';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import '../../../domain/use_case/add_notify_use_case.dart';
import '../../../domain/use_case/get_notifies_use_case.dart';
import '../../base_controller.dart';
import '../../mapper/notify_view_model_mapper.dart';
import '../../view_model/notify_view_model.dart';

class HomeController extends BaseController {
  final GetNotifiesUseCase _getNotifiesUseCase;
  final AddNotifyUseCase _addNotifyUseCase;

  HomeController(this._getNotifiesUseCase, this._addNotifyUseCase);

  final notifies = <NotifyViewModel>[].obs;
  StreamSubscription<LocationData>? locationSubscription;

  @override
  void onReady() {
    super.onReady();
    getNotifies();
  }

  @override
  void onClose() {
    _stopLocation();
    super.onClose();
  }

  void addNotify() async {
    await _addNotifyUseCase.invoke();
    getNotifies();
  }

  void getNotifies() async {
    final notifyEntities = await _getNotifiesUseCase.invoke();
    final notifyViewModels = notifyEntities.map((e) => e.toNotifyViewModel()).toList();
    notifies(notifyViewModels);

    _stopLocation();
    final isOn = notifyViewModels.firstWhereOrNull((element) => element.isEnabled == true);
    if (isOn == null) {
      return;
    }
    _startLocation();
  }

  void _startLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    await location.enableBackgroundMode();
    await location.changeNotificationOptions(
      title: 'Geolocation',
      subtitle: 'Geolocation detection',
    );

    locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
      final notify = notifies.value.firstWhereOrNull((element) => element.isEnabled == true);
      if (notify == null) {
        return;
      }
      if (currentLocation.latitude == null || currentLocation.longitude == null) {
        return;
      }

      final meter = const Distance().call(
        LatLng(currentLocation.latitude!, currentLocation.longitude!),
        LatLng(notify.latitude, notify.longitude),
      );

      print("${meter}");
      if (meter <= notify.radius) {
        print("=========================");
        print("Alert");
        print("=========================");
      }
    });
  }

  void _stopLocation() {
    locationSubscription?.cancel();
  }
}
