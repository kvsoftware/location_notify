import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/locales.g.dart';
import '../../base_view.dart';
import '../../routes/app_pages.dart';
import '../../view_model/notify_view_model.dart';
import '../notify_detail/notify_detail_view.dart';
import 'home_controller.dart';

class HomeView extends BaseView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.home_title.tr)),
      body: Obx(() => _buildListView(context)),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_location_alt_outlined),
        onPressed: () {
          controller.addNotify();
        },
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      itemCount: controller.notifies.length,
      itemBuilder: (context, index) {
        return _buildItem(controller.notifies[index]);
      },
    );
  }

  Widget _buildItem(NotifyViewModel notifyViewModel) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.NOTIFY_DETAIL, arguments: NotifyDetailArgument(notifyViewModel.id))?.then((value) {
            controller.getNotifies();
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notifyViewModel.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notifyViewModel.address,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Switch(
                value: notifyViewModel.isEnabled,
                onChanged: (bool value) {
                  controller.updateStatus(notifyViewModel, value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
