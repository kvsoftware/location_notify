import '../../domain/entity/notify_entity.dart';
import '../../domain/mapper/notify_entity_mapper.dart';
import '../datasource/local/model/notify_db_model.dart';
import '../datasource/local/notify_local_data_source.dart';
import '../mapper/notify_model_mapper.dart';

class NotifyRepository {
  final NotifyLocalDataSource _notifyLocalDataSource;

  NotifyRepository(this._notifyLocalDataSource);

  Future<NotifyEntity?> getNotifyById({required int id}) async {
    final notifyDbModel = await _notifyLocalDataSource.getNotifyById(id: id);
    return notifyDbModel?.toNotifyEntity();
  }

  Future<List<NotifyEntity>> getNotifies() async {
    final notifyDbModels = await _notifyLocalDataSource.getNotifies();
    return notifyDbModels.map((e) => e.toNotifyEntity()).toList();
  }

  Future<void> insertNotify(NotifyEntity notifyEntity) {
    return _notifyLocalDataSource.insertNotify(notifyEntity.toNotifyDbModel());
  }

  Future<void> deleteNotify(NotifyDbModel notifyDbModel) {
    return _notifyLocalDataSource.deleteNotify(notifyDbModel);
  }
}
