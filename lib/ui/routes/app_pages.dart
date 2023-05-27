import 'package:get/get.dart';

import '../page/search_location/search_location_binding.dart';
import '../page/search_location/search_location_view.dart';
import '../page/home/home_binding.dart';
import '../page/home/home_view.dart';
import '../page/map/map_binding.dart';
import '../page/map/map_view.dart';
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
    GetPage(
      name: _Paths.MAP,
      page: () => const MapView(),
      binding: MapBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_LOCATION,
      page: () => const SearchLocationView(),
      binding: SearchLocationBinding(),
    ),
  ];
}
