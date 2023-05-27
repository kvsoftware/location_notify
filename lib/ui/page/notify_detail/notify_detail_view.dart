import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../generated/locales.g.dart';
import '../../base_view.dart';
import '../../routes/app_pages.dart';
import '../../view_model/notify_detail_view_model.dart';
import '../map/map_view.dart';
import 'notify_detail_controller.dart';

class NotifyDetailArgument {
  final int id;
  NotifyDetailArgument(this.id);
}

class NotifyDetailView extends BaseView<NotifyDetailController> {
  const NotifyDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        appBar: AppBar(title: Text(LocaleKeys.notify_detail_title.tr)),
        body: Obx(
          () => Stack(
            children: [
              if (controller.notifyDetail.value != null) _buildNotifyDetail(controller.notifyDetail.value!),
              if (controller.isLoading.isTrue) const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotifyDetail(NotifyDetailViewModel notifyDetailViewModel) {
    return Column(
      children: [
        _buildMap(notifyDetailViewModel),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.label_outline),
          title: Text(notifyDetailViewModel.name),
          onTap: () => _showDialogEditName(notifyDetailViewModel.name),
        ),
        ListTile(
          leading: const Icon(Icons.radar),
          title: Text("${notifyDetailViewModel.radius} ${LocaleKeys.notify_detail_text_metres.tr}"),
          onTap: () => _showDialogEditRadius(notifyDetailViewModel.radius),
        ),
        ListTile(
          minVerticalPadding: 0,
          leading: const Icon(Icons.delete_outlined),
          title: Text(LocaleKeys.notify_detail_text_delete.tr),
          onTap: () => _showDialogDeleteConfirmation(),
        )
      ],
    );
  }

  Widget _buildMap(NotifyDetailViewModel notifyDetailViewModel) {
    return Expanded(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(notifyDetailViewModel.latitude, notifyDetailViewModel.longitude),
              zoom: 16,
            ),
            zoomGesturesEnabled: false,
            scrollGesturesEnabled: false,
            markers: Set<Marker>.of(controller.markers),
            circles: Set<Circle>.of(controller.circles),
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) => this.controller.onMapCreated(controller),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 16, 16, 0),
              child: FloatingActionButton(
                onPressed: () async {
                  final address = await Get.toNamed(
                    Routes.MAP,
                    arguments: MapViewArgument(
                      notifyDetailViewModel.latitude,
                      notifyDetailViewModel.longitude,
                    ),
                  );
                  controller.updateNotifyAddress(address);
                },
                child: const Icon(Icons.edit_location_alt_outlined),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showDialogEditName(String name) async {
    final textEditingController = TextEditingController();
    textEditingController.text = name;
    Get.defaultDialog(
      title: LocaleKeys.notify_detail_dialog_edit_name_title.tr,
      content: TextField(controller: textEditingController),
      textConfirm: LocaleKeys.global_ok.tr,
      textCancel: LocaleKeys.global_cancel.tr,
      onConfirm: () {
        Get.back();
        controller.updateNotifyName(textEditingController.text);
      },
    );
  }

  _showDialogEditRadius(double radius) async {
    final textEditingController = TextEditingController();
    textEditingController.text = radius.toString();
    Get.defaultDialog(
      title: LocaleKeys.notify_detail_dialog_edit_radius_title.tr,
      content: TextField(controller: textEditingController, keyboardType: TextInputType.number),
      textConfirm: LocaleKeys.global_ok.tr,
      textCancel: LocaleKeys.global_cancel.tr,
      onConfirm: () {
        Get.back();
        controller.updateNotifyRadius(textEditingController.text);
      },
    );
  }

  _showDialogDeleteConfirmation() async {
    Get.defaultDialog(
      title: LocaleKeys.notify_detail_dialog_delete_notify_title.tr,
      middleText: LocaleKeys.notify_detail_dialog_delete_notify_message.tr,
      textConfirm: LocaleKeys.global_ok.tr,
      textCancel: LocaleKeys.global_cancel.tr,
      onConfirm: () {
        Get.back();
        controller.deleteNotify();
      },
    );
  }

  Future<bool> _onWillPop() async {
    await controller.updateNotify();
    return true;
  }
}
