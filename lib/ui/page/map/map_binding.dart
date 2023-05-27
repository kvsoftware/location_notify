import 'package:get/get.dart';

import '../../../domain/use_case/get_address_by_lat_lon_use_case.dart';
import 'map_controller.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetAddressByLatLonUseCase>(() => GetAddressByLatLonUseCase(Get.find()));
    Get.lazyPut<MapController>(() => MapController(Get.find()));
  }
}
