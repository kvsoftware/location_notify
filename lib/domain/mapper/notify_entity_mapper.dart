import '../../data/datasource/local/model/notify_db_model.dart';
import '../../domain/entity/notify_entity.dart';

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
