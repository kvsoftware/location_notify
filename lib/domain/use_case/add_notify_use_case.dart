import '../../data/repository/map_repository.dart';
import '../../data/repository/notify_repository.dart';
import '../entity/notify_entity.dart';

class AddNotifyUseCase {
  final MapRepository _mapRepository;
  final NotifyRepository _notifyRepository;

  AddNotifyUseCase(this._mapRepository, this._notifyRepository);

  Future<void> invoke({
    required String name,
    required double lat,
    required double lon,
    required double radius,
    required String address,
    required bool isEnabled,
  }) async {
    final addressEntity = await _mapRepository.getAddressByLatLng(latitude: lat, longitude: lon);
    return _notifyRepository.insertNotify(
      NotifyEntity(
        id: null,
        name: name,
        latitude: addressEntity.latitude,
        longitude: addressEntity.longitude,
        radius: radius,
        address: addressEntity.displayName,
        isEnabled: isEnabled,
      ),
    );
  }
}
