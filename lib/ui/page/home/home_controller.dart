import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../domain/use_case/add_notify_use_case.dart';
import '../../../domain/use_case/get_notifies_use_case.dart';
import '../../../domain/use_case/update_notify_use_case.dart';
import '../../../generated/locales.g.dart';
import '../../base_controller.dart';
import '../../mapper/notify_view_model_mapper.dart';
import '../../view_model/notify_view_model.dart';

class HomeController extends BaseController {
  final GetNotifiesUseCase _getNotifiesUseCase;
  final AddNotifyUseCase _addNotifyUseCase;
  final UpdateNotifyUseCase _updateNotifyUseCase;

  HomeController(this._getNotifiesUseCase, this._addNotifyUseCase, this._updateNotifyUseCase);

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
      title: LocaleKeys.background_location_noti_android_title.tr,
      subtitle: LocaleKeys.background_location_noti_android_subtitle.tr,
      iconName: "ic_notification",
    );

    locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) async {
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

      if (meter <= notify.radius) {
        final notifyViewModel = NotifyViewModel(
            id: notify.id,
            name: notify.name,
            address: notify.address,
            latitude: notify.latitude,
            longitude: notify.longitude,
            radius: notify.radius,
            isEnabled: false);

        _updateNotify(notifyViewModel);
        getNotifies();
        _showNotification(notifyViewModel);
      }
    });
  }

  void _stopLocation() {
    locationSubscription?.cancel();
  }

  void _updateNotify(NotifyViewModel notifyViewModel) async {
    isLoading(true);
    await _updateNotifyUseCase.invoke(notifyEntity: notifyViewModel.toNotifyEntity());
    isLoading(false);
  }

  void _showNotification(NotifyViewModel notifyViewModel) async {
    const androidNotificationDetails = AndroidNotificationDetails(
      'notification',
      'Messages',
      importance: Importance.max,
      priority: Priority.high,
      icon: "ic_notification",
    );
    const notificationDetails = NotificationDetails(android: androidNotificationDetails);
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
      UniqueKey().hashCode,
      LocaleKeys.alert_notification_title.tr,
      "${LocaleKeys.alert_notification_message.tr} ${notifyViewModel.name}",
      notificationDetails,
    );
  }
}
