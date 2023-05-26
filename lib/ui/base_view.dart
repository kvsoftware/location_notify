import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseView<T> extends GetView<T> {
  const BaseView({super.key});

  Widget buildNoInternetConnectionLayout(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      color: Colors.blueGrey,
      child: const Text("No internet connection", textAlign: TextAlign.center),
    );
  }
}
