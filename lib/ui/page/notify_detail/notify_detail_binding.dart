import 'package:get/get.dart';

import '../../../domain/use_case/delete_notify_by_id_use_case.dart';
import '../../../domain/use_case/get_notify_by_id_use_case.dart';
import '../../../domain/use_case/update_notify_use_case.dart';
import 'notify_detail_controller.dart';

class NotifydetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetNotifyByIdUseCase>(() => GetNotifyByIdUseCase(Get.find()));
    Get.lazyPut<UpdateNotifyUseCase>(() => UpdateNotifyUseCase(Get.find()));
    Get.lazyPut<DeleteNotifyByIdUseCase>(() => DeleteNotifyByIdUseCase(Get.find()));
    Get.lazyPut<NotifyDetailController>(() => NotifyDetailController(Get.find(), Get.find(), Get.find()));
  }
}
