import 'package:get/get.dart';

import '../../../domain/use_case/get_notifies_use_case.dart';
import '../../../domain/use_case/update_notify_use_case.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetNotifiesUseCase>(() => GetNotifiesUseCase(Get.find()));
    Get.lazyPut<UpdateNotifyUseCase>(() => UpdateNotifyUseCase(Get.find()));
    Get.lazyPut<HomeController>(() => HomeController(Get.find(), Get.find()));
  }
}
