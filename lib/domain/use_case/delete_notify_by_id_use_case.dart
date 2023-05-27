import '../../data/repository/notify_repository.dart';

class DeleteNotifyByIdUseCase {
  final NotifyRepository _notifyRepository;

  DeleteNotifyByIdUseCase(this._notifyRepository);

  Future<void> invoke({required int id}) async {
    return _notifyRepository.deleteNotifyById(id: id);
  }
}
