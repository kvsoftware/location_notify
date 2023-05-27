import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/use_case/search_address_by_keyword_use_case.dart';
import '../../base_controller.dart';
import '../../mapper/address_view_model_mapper.dart';
import '../../view_model/address_view_model.dart';

class SearchLocationController extends BaseController {
  final SearchAddressByKeywordUseCase _searchAddressByKeywordUseCase;

  SearchLocationController(this._searchAddressByKeywordUseCase);

  final textEditingcontroller = TextEditingController();
  final addresses = <AddressViewModel>[].obs;

  Timer? _timer;
  final _delayInSeconds = 1;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void onTextChanged(String text) {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: _delayInSeconds), () {
      _searchByKeyword(text);
    });
  }

  void _searchByKeyword(String keyword) async {
    isLoading(true);
    final addresses = await _searchAddressByKeywordUseCase.invoke(keyword: keyword);
    isLoading(false);
    this.addresses(addresses.map((e) => e.toAddressViewModel()).toList());
  }
}
