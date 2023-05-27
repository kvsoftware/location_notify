class NotifyViewModel {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double radius;
  final bool isEnabled;

  NotifyViewModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.isEnabled,
  });
}
