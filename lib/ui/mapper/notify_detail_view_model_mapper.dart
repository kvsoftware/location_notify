import '../../domain/entity/notify_entity.dart';
import '../view_model/notify_detail_view_model.dart';

extension NotifyEntityMapping on NotifyEntity {
  NotifyDetailViewModel toNotifyDetailViewModel() {
    return NotifyDetailViewModel(
      id: id ?? 0,
      name: name,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      address: address,
      isEnabled: isEnabled,
    );
  }
}

extension NotifyDetailViewModelMapping on NotifyDetailViewModel {
  NotifyEntity toNotifyEntity() {
    return NotifyEntity(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      address: address,
      isEnabled: isEnabled,
    );
  }
}
