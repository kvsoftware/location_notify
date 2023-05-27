import 'package:get/get.dart';

import '../page/home/home_binding.dart';
import '../page/home/home_view.dart';
import '../page/notify_detail/notify_detail_binding.dart';
import '../page/notify_detail/notify_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFY_DETAIL,
      page: () => const NotifyDetailView(),
      binding: NotifydetailBinding(),
    ),
  ];
}
