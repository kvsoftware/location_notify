import 'database/database_module.dart';
import 'model/notify_db_model.dart';

class NotifyLocalDataSource {
  final DatabaseModule _databaseModule;

  NotifyLocalDataSource(this._databaseModule);

  Future<NotifyDbModel?> getNotifyById({required int id}) {
    return _databaseModule.notifyDao.getNotifyById(id);
  }

  Future<List<NotifyDbModel>> getNotifies() {
    return _databaseModule.notifyDao.getNotifies();
  }

  Future<void> insertNotify(NotifyDbModel notifyDbModel) {
    return _databaseModule.notifyDao.insertNotify(notifyDbModel);
  }

  Future<void> updateNotify(NotifyDbModel notifyDbModel) {
    return _databaseModule.notifyDao.updateNotify(notifyDbModel);
  }

  Future<void> deleteNotifyById({required int id}) {
    return _databaseModule.notifyDao.deleteNotifyById(id);
  }
}
