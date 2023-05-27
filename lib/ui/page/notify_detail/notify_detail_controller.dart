import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../domain/use_case/delete_notify_by_id_use_case.dart';
import '../../../domain/use_case/get_notify_by_id_use_case.dart';
import '../../../domain/use_case/update_notify_use_case.dart';
import '../../base_controller.dart';
import '../../mapper/notify_detail_view_model_mapper.dart';
import '../../view_model/address_view_model.dart';
import '../../view_model/notify_detail_view_model.dart';
import 'notify_detail_view.dart';

class NotifyDetailController extends BaseController {
  final GetNotifyByIdUseCase _getNotifyByIdUseCase;
  final UpdateNotifyUseCase _updateNotifyUseCase;
  final DeleteNotifyByIdUseCase _deleteNotifyByIdUseCase;

  NotifyDetailController(this._getNotifyByIdUseCase, this._updateNotifyUseCase, this._deleteNotifyByIdUseCase);

  final textEditingcontroller = TextEditingController();
  final markers = <Marker>[].obs;
  final circles = <Circle>[].obs;
  final notifyDetail = Rxn<NotifyDetailViewModel>();

  late GoogleMapController _googleMapController;

  @override
  void onReady() {
    super.onReady();
    final notifyId = (Get.arguments as NotifyDetailArgument).id;
    _getNotifyById(notifyId);
  }

  _getNotifyById(int id) async {
    isLoading(true);
    final notifyEntity = await _getNotifyByIdUseCase.invoke(id: id);
    isLoading(false);

    if (notifyEntity == null) {
      return;
    }
    _renderNotify(notifyEntity.toNotifyDetailViewModel());
  }

  _renderNotify(NotifyDetailViewModel notifyDetail) {
    this.markers([notifyDetail.toMarker()]);
    this.circles([notifyDetail.toCircle()]);
    this.notifyDetail(notifyDetail);
    textEditingcontroller.text = notifyDetail.name;
    _googleMapController.moveCamera(CameraUpdate.newLatLngZoom(
      LatLng(notifyDetail.latitude, notifyDetail.longitude),
      16,
    ));
  }

  onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
  }

  updateNotifyName(String name) async {
    final notifyViewModel = notifyDetail.value;
    if (notifyViewModel == null) {
      return;
    }
    var newNotifyDetail = NotifyDetailViewModel(
      id: notifyViewModel.id,
      name: name,
      address: notifyViewModel.address,
      latitude: notifyViewModel.latitude,
      longitude: notifyViewModel.longitude,
      radius: notifyViewModel.radius,
      isEnabled: notifyViewModel.isEnabled,
    );
    _renderNotify(newNotifyDetail);
  }

  updateNotifyRadius(String radius) async {
    final notifyViewModel = notifyDetail.value;
    if (notifyViewModel == null) {
      return;
    }
    var newNotifyDetail = NotifyDetailViewModel(
      id: notifyViewModel.id,
      name: notifyViewModel.name,
      address: notifyViewModel.address,
      latitude: notifyViewModel.latitude,
      longitude: notifyViewModel.longitude,
      radius: double.parse(radius),
      isEnabled: notifyViewModel.isEnabled,
    );
    _renderNotify(newNotifyDetail);
  }

  updateStatus(bool isEnabled) async {
    final notifyViewModel = notifyDetail.value;
    if (notifyViewModel == null) {
      return;
    }
    var newNotifyDetail = NotifyDetailViewModel(
      id: notifyViewModel.id,
      name: notifyViewModel.name,
      address: notifyViewModel.address,
      latitude: notifyViewModel.latitude,
      longitude: notifyViewModel.longitude,
      radius: notifyViewModel.radius,
      isEnabled: isEnabled,
    );
    _renderNotify(newNotifyDetail);
  }

  updateNotifyAddress(AddressViewModel addressViewModel) async {
    final notifyViewModel = notifyDetail.value;
    if (notifyViewModel == null) {
      return;
    }
    var newNotifyDetail = NotifyDetailViewModel(
      id: notifyViewModel.id,
      name: notifyViewModel.name,
      address: addressViewModel.displayName,
      latitude: addressViewModel.latitude,
      longitude: addressViewModel.longitude,
      radius: notifyViewModel.radius,
      isEnabled: notifyViewModel.isEnabled,
    );
    _renderNotify(newNotifyDetail);
  }

  updateNotify() async {
    if (notifyDetail.value == null) {
      return;
    }
    isLoading(true);
    await _updateNotifyUseCase.invoke(notifyEntity: notifyDetail.value!.toNotifyEntity());
    isLoading(false);
  }

  deleteNotify() async {
    isLoading(true);
    final notifyDetail = this.notifyDetail.value;
    isLoading(false);

    if (notifyDetail == null) {
      return;
    }
    await _deleteNotifyByIdUseCase.invoke(id: notifyDetail.id);
    isLoading(false);
    Get.back();
  }
}
