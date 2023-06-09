import '../../domain/entity/notify_entity.dart';
import '../datasource/local/model/notify_db_model.dart';

extension NotifyDbModelMapping on NotifyDbModel {
  NotifyEntity toNotifyEntity() {
    return NotifyEntity(
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

extension NotifyEntityMapping on NotifyEntity {
  NotifyDbModel toNotifyDbModel() {
    return NotifyDbModel(
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
