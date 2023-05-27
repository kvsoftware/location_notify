import 'package:floor/floor.dart';

import '../model/notify_db_model.dart';

@dao
abstract class NotifyDao {
  @Query('SELECT * FROM notify WHERE id = :id')
  Future<NotifyDbModel?> getNotifyById(int id);

  @Query('SELECT * FROM notify')
  Future<List<NotifyDbModel>> getNotifies();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertNotify(NotifyDbModel notifyDbModel);

  @Update()
  Future<void> updateNotify(NotifyDbModel notifyDbModel);

  @Query('DELETE FROM notify WHERE id = :id')
  Future<void> deleteNotifyById(int id);
}
