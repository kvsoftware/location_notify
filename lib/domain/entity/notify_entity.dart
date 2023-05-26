class NotifyEntity {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final double radius;
  final String address;
  final bool isEnabled;

  NotifyEntity({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.address,
    required this.isEnabled,
  });
}
