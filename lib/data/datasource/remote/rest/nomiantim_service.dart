import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/address_api_model.dart';

part 'nomiantim_service.g.dart';

@RestApi()
abstract class NominatimService {
  factory NominatimService(Dio dio) = _NominatimService;

  @GET("https://nominatim.openstreetmap.org/reverse")
  Future<AddressApiModel> getAddressByLatLng({
    @Query("lat") required double latitude,
    @Query("lon") required double longitude,
    @Query("format") String format = 'json',
  });

  @GET("https://nominatim.openstreetmap.org/search")
  Future<List<AddressApiModel>> searchByKeyword({
    @Query("q") required String keyword,
    @Query("format") String format = 'json',
  });
}
