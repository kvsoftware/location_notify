import 'package:get/get.dart';

import '../data/datasource/local/database/database_module.dart';
import '../data/datasource/local/notify_local_data_source.dart';
import '../data/datasource/remote/map_remote_data_source.dart';
import '../data/datasource/remote/rest/nomiantim_service.dart';
import '../data/datasource/remote/rest/rest_api_module.dart';
import '../data/repository/map_repository.dart';
import '../data/repository/notify_repository.dart';

class AppBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync(
      () => $FloorDatabaseModule.databaseBuilder('app_database.db').build(),
      permanent: true,
    );
    Get.put(getDio(''));
    Get.put(NotifyLocalDataSource(Get.find()));
    Get.put(NotifyRepository(Get.find()));
    Get.put(NominatimService(Get.find()));
    Get.put(MapRemoteDataSource(Get.find()));
    Get.put(MapRepository(Get.find()));
  }
}
