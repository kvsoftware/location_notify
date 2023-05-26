import '../../data/repository/notify_repository.dart';
import '../entity/notify_entity.dart';

class GetNotifiesUseCase {
  final NotifyRepository _notifyRepository;

  GetNotifiesUseCase(this._notifyRepository);

  Future<List<NotifyEntity>> invoke() async {
    return _notifyRepository.getNotifies();
  }
}
