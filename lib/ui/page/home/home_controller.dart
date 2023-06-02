import 'dart:io';
import 'dart:isolate';

import 'package:fl_location/fl_location.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';

import '../../../domain/entity/notify_entity.dart';
import '../../../domain/use_case/get_notifies_use_case.dart';
import '../../../domain/use_case/update_notify_use_case.dart';
import '../../../generated/locales.g.dart';
import '../../base_controller.dart';
import '../../mapper/notify_view_model_mapper.dart';
import '../../view_model/notify_view_model.dart';
import 'location_task_handler.dart';

class HomeController extends BaseController {
  final GetNotifiesUseCase _getNotifiesUseCase;
  final UpdateNotifyUseCase _updateNotifyUseCase;

  HomeController(this._getNotifiesUseCase, this._updateNotifyUseCase);

  final notifies = <NotifyViewModel>[].obs;
  ReceivePort? _receivePort;

  @override
  void onReady() {
    super.onReady();
    _initializeForegroundTask();
    _initializeNotifies();
  }

  @override
  void onClose() {
    _receivePort?.close();
    super.onClose();
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

  void _initializeNotifies() async {
    if ((await FlutterForegroundTask.isRunningService) == false) {
      final notifies = await _getNotifiesUseCase.invoke();
      final enabledNotifies = notifies.where((element) => element.isEnabled == true).toList();
      for (var notify in enabledNotifies) {
        final newNotify = NotifyEntity(
          id: notify.id,
          name: notify.name,
          address: notify.address,
          latitude: notify.latitude,
          longitude: notify.longitude,
          radius: notify.radius,
          isEnabled: false,
        );
        await _updateNotifyUseCase.invoke(notifyEntity: newNotify);
      }
    }
    getNotifies();
  }

  void _updateNotify(NotifyViewModel notifyViewModel) async {
    isLoading(true);
    await _updateNotifyUseCase.invoke(notifyEntity: notifyViewModel.toNotifyEntity());
    isLoading(false);
  }

  void _startTrackingLocation(NotifyViewModel notifyViewModel) async {
    // Check if the location is enable or not
    if (!await FlLocation.isLocationServicesEnabled) {
      await _showDialog(
        title: LocaleKeys.home_dialog_error_notify_disabled_title.tr,
        body: LocaleKeys.home_dialog_error_notify_disabled_body_location_disabled.tr,
        notifyViewModel: notifyViewModel,
      );
      return;
    }

    // Check the location permission
    var locationPermission = await FlLocation.checkLocationPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      await _showDialog(
        title: LocaleKeys.home_dialog_error_notify_disabled_title.tr,
        body: LocaleKeys.home_dialog_error_notify_disabled_body_permission_location_warning.tr,
        notifyViewModel: notifyViewModel,
      );
      return;
    }

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await FlLocation.requestLocationPermission();
      if (locationPermission == LocationPermission.denied || locationPermission == LocationPermission.deniedForever) {
        await _showDialog(
          title: LocaleKeys.home_dialog_error_notify_disabled_title.tr,
          body: LocaleKeys.home_dialog_error_notify_disabled_body_permission_location_warning.tr,
          notifyViewModel: notifyViewModel,
        );
        return;
      }
      if (locationPermission == LocationPermission.whileInUse) {
        await _showDialog(
          title: LocaleKeys.home_dialog_error_notify_disabled_title.tr,
          body: LocaleKeys.home_dialog_error_notify_disabled_body_permission_background_location_warning.tr,
          notifyViewModel: notifyViewModel,
        );
        return;
      }
    }

    if (locationPermission == LocationPermission.whileInUse) {
      locationPermission = await FlLocation.requestLocationPermission();
      if (locationPermission != LocationPermission.always) {
        await _showDialog(
          title: LocaleKeys.home_dialog_error_notify_disabled_title.tr,
          body: LocaleKeys.home_dialog_error_notify_disabled_body_permission_background_location_warning.tr,
          notifyViewModel: notifyViewModel,
        );
        return;
      }
    }

    if (Platform.isAndroid) {
      // if (!await FlutterForegroundTask.canDrawOverlays) {
      //   await FlutterForegroundTask.openSystemAlertWindowSettings();
      // }

      // Check the notification permission
      var notificationPermission = await FlutterForegroundTask.checkNotificationPermission();
      if (notificationPermission == NotificationPermission.permanently_denied) {
        await _showDialog(
          title: LocaleKeys.home_dialog_error_notify_disabled_title.tr,
          body: LocaleKeys.android_permission_post_notifications_warning.tr,
          notifyViewModel: notifyViewModel,
        );
        return;
      }

      if (notificationPermission == NotificationPermission.denied) {
        notificationPermission = await FlutterForegroundTask.requestNotificationPermission();
        if (notificationPermission == NotificationPermission.denied ||
            notificationPermission == NotificationPermission.permanently_denied) {
          await _showDialog(
            title: LocaleKeys.home_dialog_error_notify_disabled_title.tr,
            body: LocaleKeys.android_permission_post_notifications_warning.tr,
            notifyViewModel: notifyViewModel,
          );
          return;
        }
      }

      // Check the ignore battery optimization permission
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        final result = await FlutterForegroundTask.requestIgnoreBatteryOptimization();
        if (result == false) {
          await _showDialog(
            title: LocaleKeys.home_dialog_warning_ignore_battery_optimization_battery_title.tr,
            body: LocaleKeys.home_dialog_warning_ignore_battery_optimization_battery_body.tr,
          );
          return;
        }
      }
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
    await FlutterForegroundTask.stopService();
    await FlutterForegroundTask.saveData(key: 'notification_title', value: LocaleKeys.alert_notification_title.tr);
    await FlutterForegroundTask.saveData(key: 'notification_body', value: LocaleKeys.alert_notification_body.tr);
  }

  Future<void> _showDialog({required String title, required String body, NotifyViewModel? notifyViewModel}) {
    if (notifyViewModel != null) {
      updateStatus(notifyViewModel, false);
    }
    return Get.defaultDialog(
      title: title,
      middleText: body,
      textConfirm: LocaleKeys.global_ok.tr,
      onConfirm: () {
        Get.back();
      },
    );
  }
}
