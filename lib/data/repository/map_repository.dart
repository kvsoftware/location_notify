import '../../domain/entity/address_entity.dart';
import '../datasource/remote/map_remote_data_source.dart';
import '../mapper/address_model_mapper.dart';

class MapRepository {
  final MapRemoteDataSource _mapRemoteDataSource;

  MapRepository(this._mapRemoteDataSource);

  Future<AddressEntity> getAddressByLatLng({required double latitude, required double longitude}) async {
    final addressApiModel = await _mapRemoteDataSource.getAddressByLatLng(latitude: latitude, longitude: longitude);
    return addressApiModel.toAddressEntity();
  }
}
