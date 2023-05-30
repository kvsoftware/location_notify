import 'dart:io';
import 'dart:isolate';

import 'package:fl_location/fl_location.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';

import '../../../domain/use_case/add_notify_use_case.dart';
import '../../../domain/use_case/get_notifies_use_case.dart';
import '../../../domain/use_case/update_notify_use_case.dart';
import '../../../generated/locales.g.dart';
import '../../base_controller.dart';
import '../../mapper/notify_view_model_mapper.dart';
import '../../view_model/notify_view_model.dart';
import 'location_task_handler.dart';

class HomeController extends BaseController {
  final GetNotifiesUseCase _getNotifiesUseCase;
  final AddNotifyUseCase _addNotifyUseCase;
  final UpdateNotifyUseCase _updateNotifyUseCase;

  HomeController(this._getNotifiesUseCase, this._addNotifyUseCase, this._updateNotifyUseCase);

  final notifies = <NotifyViewModel>[].obs;
  ReceivePort? _receivePort;

  @override
  void onReady() {
    super.onReady();
    _initializeForegroundTask();
    getNotifies();
  }

  @override
  void onClose() {
    _receivePort?.close();
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

    _stopTrackingLocation();
    final notifyViewModel = notifyViewModels.firstWhereOrNull((element) => element.isEnabled == true);
    if (notifyViewModel == null) {
      return;
    }
    _startTrackingLocation(notifyViewModel);
  }

  void updateStatus(NotifyViewModel notifyViewModel, bool isEnabled) {
    final newNotifyViewModel = NotifyViewModel(
      id: notifyViewModel.id,
      name: notifyViewModel.name,
      address: notifyViewModel.address,
      latitude: notifyViewModel.latitude,
      longitude: notifyViewModel.longitude,
      radius: notifyViewModel.radius,
      isEnabled: isEnabled,
    );
    _updateNotify(newNotifyViewModel);
    getNotifies();
  }

  void _updateNotify(NotifyViewModel notifyViewModel) async {
    isLoading(true);
    await _updateNotifyUseCase.invoke(notifyEntity: notifyViewModel.toNotifyEntity());
    isLoading(false);
  }

  void _startTrackingLocation(NotifyViewModel notifyViewModel) async {
    if (Platform.isAndroid) {
      if (!await FlutterForegroundTask.canDrawOverlays) {
        await FlutterForegroundTask.openSystemAlertWindowSettings();
      }

      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }

      final notificationPermissionStatus = await FlutterForegroundTask.checkNotificationPermission();
      if (notificationPermissionStatus != NotificationPermission.granted) {
        await FlutterForegroundTask.requestNotificationPermission();
      }
    }

    if (!await FlLocation.isLocationServicesEnabled) {
      return;
    }
    final locationPermission = await FlLocation.checkLocationPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      return;
    }
    if (locationPermission == LocationPermission.denied) {
      final locationPermission = await FlLocation.requestLocationPermission();
      if (locationPermission == LocationPermission.denied || locationPermission == LocationPermission.deniedForever) {
        return;
      }
    }
    if (locationPermission == LocationPermission.whileInUse) {
      return;
    }

    _receivePort = FlutterForegroundTask.receivePort;
    _receivePort?.listen((data) {
      if (data is bool && data == true) {
        getNotifies();
      }
    });
    if (await FlutterForegroundTask.isRunningService) {
      return;
    } else {
      await FlutterForegroundTask.startService(
        notificationTitle: LocaleKeys.android_foreground_service_notification_title.tr,
        notificationText: LocaleKeys.android_foreground_service_notification_body.tr,
        callback: startCallback,
      );
    }
  }

  void _stopTrackingLocation() async {
    await FlutterForegroundTask.stopService();
  }

  void _initializeForegroundTask() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        id: 500,
        channelId: 'foregroud',
        channelName: 'Foreground',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
    await FlutterForegroundTask.saveData(key: 'notification_title', value: LocaleKeys.alert_notification_title.tr);
    await FlutterForegroundTask.saveData(key: 'notification_body', value: LocaleKeys.alert_notification_body.tr);
  }
}
