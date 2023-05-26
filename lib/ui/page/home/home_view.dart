import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/locales.g.dart';
import '../../base_view.dart';
import '../../view_model/notify_view_model.dart';
import 'home_controller.dart';

class HomeView extends BaseView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.home_title.tr), centerTitle: true),
      body: Obx(
        () => Stack(
          children: [
            _buildListView(context),
            _buildCreateNotifyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      itemCount: controller.notifies.length,
      itemBuilder: (context, index) {
        return _buildItem(controller.notifies.value[index]);
      },
    );
  }

  Widget _buildItem(NotifyViewModel notifyViewModel) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: InkWell(
        onTap: () {
          // Do something
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
                  // Do something
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateNotifyButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
          onPressed: () {
            controller.addNotify();
          },
          child: const Icon(Icons.alarm_add),
        ),
      ),
    );
  }
}
