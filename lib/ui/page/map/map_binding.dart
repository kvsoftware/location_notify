import 'package:get/get.dart';

import '../../../domain/use_case/add_notify_use_case.dart';
import '../../../domain/use_case/get_address_by_lat_lon_use_case.dart';
import 'map_controller.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddNotifyUseCase>(() => AddNotifyUseCase(Get.find(), Get.find()));
    Get.lazyPut<GetAddressByLatLonUseCase>(() => GetAddressByLatLonUseCase(Get.find()));
    Get.lazyPut<MapController>(() => MapController(Get.find(), Get.find()));
  }
}
