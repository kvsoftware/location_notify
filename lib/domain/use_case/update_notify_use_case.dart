import '../../data/repository/notify_repository.dart';
import '../entity/notify_entity.dart';

class UpdateNotifyUseCase {
  final NotifyRepository _notifyRepository;

  UpdateNotifyUseCase(this._notifyRepository);

  Future<NotifyEntity?> invoke({required NotifyEntity notifyEntity}) async {
    await _notifyRepository.updateNotify(notifyEntity);
    return _notifyRepository.getNotifyById(id: notifyEntity.id!);
  }
}
