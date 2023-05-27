import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../domain/use_case/get_address_by_lat_lon_use_case.dart';
import '../../base_controller.dart';
import '../../mapper/address_view_model_mapper.dart';
import '../../view_model/address_view_model.dart';
import 'map_view.dart';

class MapController extends BaseController {
  final GetAddressByLatLonUseCase _getAddressByLatLonUseCase;

  MapController(this._getAddressByLatLonUseCase);

  double defaultLatitude = 54.5512799;
  double defaultLongitude = -4.4737716;
  double defaultZoom = 18;

  final address = Rxn<AddressViewModel>();
  double latitude = 0.0;
  double longitude = 0.0;
  double zoom = 18;

  late GoogleMapController _googleMapController;

  @override
  void onReady() {
    super.onReady();
  }

  void onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
    final arguments = (Get.arguments as MapViewArgument?);
    if (arguments == null) {
      return;
    }
    latitude = arguments.latitude;
    longitude = arguments.longitude;
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

  void onCameraMove2(AddressViewModel addressViewModel) {
    latitude = addressViewModel.latitude;
    longitude = addressViewModel.longitude;
    _googleMapController.moveCamera(CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), defaultZoom));
  }

  void onCameraIdle() {
    getAddressName();
  }
}
