import 'dart:async';
import 'dart:isolate';

import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/datasource/local/database/database_module.dart';
import '../../../data/datasource/local/notify_local_data_source.dart';
import '../../../data/repository/notify_repository.dart';
import '../../../domain/entity/notify_entity.dart';
import '../../../domain/use_case/get_notifies_use_case.dart';
import '../../../domain/use_case/update_notify_use_case.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
}

class LocationTaskHandler extends TaskHandler {
  StreamSubscription<Location>? _streamSubscription;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    final notificationTitle = await FlutterForegroundTask.getData<String>(key: 'notification_title') ?? '';
    final notificationBody = await FlutterForegroundTask.getData<String>(key: 'notification_body') ?? '';

    final dataModule = await $FloorDatabaseModule.databaseBuilder('app_database.db').build();
    final notifyLocalDataSource = NotifyLocalDataSource(dataModule);
    final notifyRepository = NotifyRepository(notifyLocalDataSource);
    final getNotifiesUseCase = GetNotifiesUseCase(notifyRepository);
    final updateNotifyUseCase = UpdateNotifyUseCase(notifyRepository);

    _streamSubscription = FlLocation.getLocationStream().listen(
      (event) async {
        final notifies = await getNotifiesUseCase.invoke();
        final enabledNotifies = notifies.where((element) => element.isEnabled).toList();
        if (enabledNotifies.isEmpty) {
          await FlutterForegroundTask.stopService();
          return;
        }

        for (var notify in enabledNotifies) {
          final meter = const Distance().call(
            LatLng(event.latitude, event.longitude),
            LatLng(notify.latitude, notify.longitude),
          );

          if (meter <= notify.radius) {
            final newNotify = NotifyEntity(
              id: notify.id,
              name: notify.name,
              address: notify.address,
              latitude: notify.latitude,
              longitude: notify.longitude,
              radius: notify.radius,
              isEnabled: false,
            );
            await updateNotifyUseCase.invoke(notifyEntity: newNotify);
            sendPort?.send(true);
            _showAlertNotification("${notificationTitle} ${notify.name}", notificationBody);
          }
        }
      },
    );
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    // Do nothing
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    await _streamSubscription?.cancel();
  }

  @override
  void onButtonPressed(String id) {}

  @override
  void onNotificationPressed() {}

  void _showAlertNotification(notificationTitle, notificationBody) async {
    const androidNotificationDetails = AndroidNotificationDetails(
      'notification',
      'Alert',
      importance: Importance.max,
      priority: Priority.high,
      icon: "@mipmap/ic_launcher",
    );
    const notificationDetails = NotificationDetails(android: androidNotificationDetails);
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
      UniqueKey().hashCode,
      notificationTitle,
      notificationBody,
      notificationDetails,
    );
  }
}
