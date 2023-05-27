import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/locales.g.dart';
import '../../base_view.dart';
import '../../view_model/address_view_model.dart';
import 'search_location_controller.dart';

class SearchLocationView extends BaseView<SearchLocationController> {
  const SearchLocationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.search_location_title.tr)),
      body: Obx(
        () => Stack(
          children: [
            Column(
              children: [
                _buildSearchTextField(),
                _buildListView(),
              ],
            ),
            if (controller.isLoading.isTrue) const Center(child: CircularProgressIndicator()),
            if (controller.isLoading.isFalse &&
                controller.textEditingcontroller.text.isNotEmpty &&
                controller.addresses.isEmpty)
              Center(child: Text(LocaleKeys.search_location_text_not_found.tr)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTextField() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: controller.textEditingcontroller,
          onChanged: (value) => controller.onTextChanged(value),
          decoration: InputDecoration(
            hintText: LocaleKeys.search_location_textfield_search_hint.tr,
            suffixIcon: const Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: controller.addresses.length,
        itemBuilder: (context, index) {
          return _buildItem(controller.addresses.value[index]);
        },
      ),
    );
  }

  Widget _buildItem(AddressViewModel addressViewModel) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: InkWell(
        onTap: () {
          Get.back(result: addressViewModel);
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
                      addressViewModel.displayName,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
