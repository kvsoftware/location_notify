import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../generated/locales.g.dart';
import '../../base_view.dart';
import '../../routes/app_pages.dart';
import 'map_controller.dart';

class MapViewArgument {
  final bool isNotifyCreated;
  final double? latitude;
  final double? longitude;

  MapViewArgument({required this.isNotifyCreated, this.latitude, this.longitude});
}

class MapView extends BaseView<MapController> {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.map_title.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final address = await Get.toNamed(Routes.SEARCH_LOCATION);
              if (address == null) {
                return;
              }
              controller.moveCameraByAddress(address);
            },
          )
        ],
      ),
      body: Obx(
        () => Stack(
          children: [
            _buildMap(),
            _buildAddress(),
            _buildMarker(context),
            _buildSubmit(),
            if (controller.isLoading.isTrue) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return Expanded(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(controller.defaultLatitude, controller.defaultLongitude),
              zoom: controller.defaultZoom,
            ),
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) => this.controller.onMapCreated(controller),
            onCameraMove: (position) => controller.onCameraMove(position),
            onCameraIdle: () => controller.onCameraIdle(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddress() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: Get.width,
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(controller.address.value?.displayName ?? ''),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmit() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: Get.width,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: ElevatedButton(
          onPressed: () {
            controller.onSubmit();
          },
          child: Text(LocaleKeys.map_button_select_address.tr),
        ),
      ),
    );
  }

  Widget _buildMarker(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.only(bottom: 35),
        child: Icon(Icons.location_on_rounded, size: 50, color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}
