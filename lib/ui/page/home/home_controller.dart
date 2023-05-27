import 'package:get/get.dart';

import '../../../domain/use_case/add_notify_use_case.dart';
import '../../../domain/use_case/get_notifies_use_case.dart';
import '../../base_controller.dart';
import '../../mapper/notify_view_model_mapper.dart';
import '../../view_model/notify_view_model.dart';

class HomeController extends BaseController {
  final GetNotifiesUseCase _getNotifiesUseCase;
  final AddNotifyUseCase _addNotifyUseCase;

  HomeController(this._getNotifiesUseCase, this._addNotifyUseCase);

  final notifies = <NotifyViewModel>[].obs;

  @override
  void onReady() {
    super.onReady();
    getNotifies();
  }

  void addNotify() async {
    await _addNotifyUseCase.invoke();
    getNotifies();
  }

  void getNotifies() async {
    final notifyEntities = await _getNotifiesUseCase.invoke();
    notifies(notifyEntities.map((e) => e.toNotifyViewModel()).toList());
  }
}
