import 'package:get/get.dart';

import '../../../domain/use_case/search_address_by_keyword_use_case.dart';
import 'search_location_controller.dart';

class SearchLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchAddressByKeywordUseCase>(() => SearchAddressByKeywordUseCase(Get.find()));
    Get.lazyPut<SearchLocationController>(() => SearchLocationController(Get.find()));
  }
}
