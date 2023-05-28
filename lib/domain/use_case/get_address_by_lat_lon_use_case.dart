import '../../data/repository/map_repository.dart';
import '../entity/address_entity.dart';

class GetAddressByLatLonUseCase {
  final MapRepository _mapRepository;

  GetAddressByLatLonUseCase(this._mapRepository);

  Future<AddressEntity> invoke({required double latitude, required double longitude}) async {
    return await _mapRepository.getAddressByLatLng(latitude: latitude, longitude: longitude);
  }
}
