import '../../data/repository/notify_repository.dart';
import '../entity/notify_entity.dart';

class GetNotifyByIdUseCase {
  final NotifyRepository _notifyRepository;

  GetNotifyByIdUseCase(this._notifyRepository);

  Future<NotifyEntity?> invoke({required int id}) async {
    return _notifyRepository.getNotifyById(id: id);
  }
}
