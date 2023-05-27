import '../../domain/entity/notify_entity.dart';
import '../view_model/notify_view_model.dart';

extension NotifyEntityMapper on NotifyEntity {
  NotifyViewModel toNotifyViewModel() {
    return NotifyViewModel(
      id: id ?? 0,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      isEnabled: isEnabled,
    );
  }
}
