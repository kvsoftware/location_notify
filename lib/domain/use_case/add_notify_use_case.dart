import '../../data/repository/map_repository.dart';
import '../../data/repository/notify_repository.dart';
import '../entity/notify_entity.dart';

class AddNotifyUseCase {
  final MapRepository _mapRepository;
  final NotifyRepository _notifyRepository;

  AddNotifyUseCase(this._mapRepository, this._notifyRepository);

  Future<void> invoke({
    String name = '',
    double lat = 0.0,
    double lon = 0.0,
    double radius = 0,
    String address = '',
    bool isEnabled = false,
  }) async {
    final addressEntity = await _mapRepository.getAddressByLatLng(latitude: 55.888208, longitude: -4.288087);

    return _notifyRepository.insertNotify(
      NotifyEntity(
        id: null,
        name: "Test1",
        latitude: addressEntity.latitude,
        longitude: addressEntity.longitude,
        radius: radius,
        address: addressEntity.displayName,
        isEnabled: false,
      ),
    );
  }
}
