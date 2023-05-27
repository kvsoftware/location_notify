import 'model/address_api_model.dart';
import 'rest/nomiantim_service.dart';

class MapRemoteDataSource {
  final NominatimService _nominatimService;

  MapRemoteDataSource(this._nominatimService);

  Future<AddressApiModel> getAddressByLatLng({
    required double latitude,
    required double longitude,
  }) async {
    return _nominatimService.getAddressByLatLng(latitude: latitude, longitude: longitude);
  }

  Future<List<AddressApiModel>> searchByKeyword({required String keyword}) async {
    return _nominatimService.searchByKeyword(keyword: keyword);
  }
}
