import '../../domain/entity/address_entity.dart';
import '../view_model/address_view_model.dart';

extension AddressEntityMapper on AddressEntity {
  AddressViewModel toAddressViewModel() {
    return AddressViewModel(
      placeId: placeId,
      latitude: latitude,
      longitude: longitude,
      displayName: displayName,
    );
  }
}
