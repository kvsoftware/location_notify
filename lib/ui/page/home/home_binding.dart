import 'package:get/get.dart';

import '../../../domain/use_case/add_notify_use_case.dart';
import '../../../domain/use_case/get_notifies_use_case.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetNotifiesUseCase>(() => GetNotifiesUseCase(Get.find()));
    Get.lazyPut<AddNotifyUseCase>(() => AddNotifyUseCase(Get.find(), Get.find()));
    Get.lazyPut<HomeController>(() => HomeController(Get.find(), Get.find()));
  }
}
