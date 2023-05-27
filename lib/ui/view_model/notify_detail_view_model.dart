import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NotifyDetailViewModel {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double radius;
  final bool isEnabled;

  NotifyDetailViewModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.isEnabled,
  });

  Marker toMarker() {
    return Marker(markerId: MarkerId((id ?? 0).toString()), position: LatLng(latitude, longitude), flat: true);
  }

  Circle toCircle() {
    BuildContext? context = Get.context;
    Color color;
    if (context != null) {
      color = Theme.of(context).colorScheme.secondary.withOpacity(0.3);
    } else {
      color = Colors.transparent;
    }
    return Circle(
      circleId: CircleId((id ?? 0).toString()),
      center: LatLng(latitude, longitude),
      radius: radius,
      fillColor: color,
      strokeWidth: 1,
    );
  }
}
