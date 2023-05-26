import '../../domain/entity/notify_entity.dart';
import '../view_model/notify_view_model.dart';

extension NotifyEntityMapper on NotifyEntity {
  NotifyViewModel toNotifyViewModel() {
    return NotifyViewModel(
      id: id ?? 0,
      name: name,
      address: address,
      isEnabled: isEnabled,
    );
  }
}
