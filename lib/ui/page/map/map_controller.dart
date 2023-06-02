import 'package:fl_location/fl_location.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../domain/use_case/add_notify_use_case.dart';
import '../../../domain/use_case/get_address_by_lat_lon_use_case.dart';
import '../../../generated/locales.g.dart';
import '../../base_controller.dart';
import '../../mapper/address_view_model_mapper.dart';
import '../../view_model/address_view_model.dart';
import 'map_view.dart';

class MapController extends BaseController {
  final GetAddressByLatLonUseCase _getAddressByLatLonUseCase;
  final AddNotifyUseCase _addNotifyUseCase;

  MapController(this._getAddressByLatLonUseCase, this._addNotifyUseCase);

  double defaultLatitude = 55.864272;
  double defaultLongitude = -4.251862;
  double defaultZoom = 14;

  final address = Rxn<AddressViewModel>();
  double latitude = 0.0;
  double longitude = 0.0;
  double zoom = 18;

  GoogleMapController? _googleMapController;

  void onMyLocationButtonClicked() async {
    if (_googleMapController == null) {
      return;
    }

    // Check if the location is enable or not
    if (!await FlLocation.isLocationServicesEnabled) {
      await _showDialog(
        title: LocaleKeys.map_dialog_error_my_location_title.tr,
        body: LocaleKeys.map_dialog_error_my_location_body_location_disabled.tr,
      );
      return;
    }

    // Check the location permission
    var locationPermission = await FlLocation.checkLocationPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      await _showDialog(
        title: LocaleKeys.map_dialog_error_my_location_title.tr,
        body: LocaleKeys.map_dialog_error_my_location_permission_location_warning.tr,
      );
      return;
    }

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await FlLocation.requestLocationPermission();
      if (locationPermission == LocationPermission.denied || locationPermission == LocationPermission.deniedForever) {
        await _showDialog(
          title: LocaleKeys.map_dialog_error_my_location_title.tr,
          body: LocaleKeys.map_dialog_error_my_location_permission_location_warning.tr,
        );
        return;
      }
    }

    isLoading(true);
    final location = await FlLocation.getLocation();
    _googleMapController!.animateCamera(CameraUpdate.newLatLng(LatLng(location.latitude, location.longitude)));
    isLoading(false);
  }

  void onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
    final arguments = (Get.arguments as MapViewArgument);
    latitude = arguments.latitude ?? defaultLatitude;
    longitude = arguments.longitude ?? defaultLongitude;
    controller.moveCamera(CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), defaultZoom));
    getAddressName();
  }

  void getAddressName() async {
    isLoading(true);
    final address = await _getAddressByLatLonUseCase.invoke(latitude: latitude, longitude: longitude);
    isLoading(false);
    this.address(address.toAddressViewModel());
  }

  void onCameraMove(CameraPosition cameraPosition) {
    latitude = cameraPosition.target.latitude;
    longitude = cameraPosition.target.longitude;
    zoom = cameraPosition.zoom;
  }

  void moveCameraByAddress(AddressViewModel addressViewModel) {
    latitude = addressViewModel.latitude;
    longitude = addressViewModel.longitude;
    _googleMapController?.moveCamera(CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), defaultZoom));
  }

  void onCameraIdle() {
    getAddressName();
  }

  void onSubmit() {
    final arguments = (Get.arguments as MapViewArgument);
    if (arguments.isNotifyCreated) {
      addNotify();
    } else {
      Get.back(result: address.value);
    }
  }

  void addNotify() async {
    if (address.value == null) {
      return;
    }
    await _addNotifyUseCase.invoke(
      name: address.value!.displayName.split(',')[0],
      lat: address.value!.latitude,
      lon: address.value!.longitude,
      address: address.value!.displayName,
      radius: 50,
      isEnabled: true,
    );
    Get.back(result: address.value);
  }

  Future<void> _showDialog({required String title, required String body}) {
    return Get.defaultDialog(
      title: title,
      middleText: body,
      textConfirm: LocaleKeys.global_ok.tr,
      onConfirm: () {
        Get.back();
      },
    );
  }
}
