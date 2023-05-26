import '../../domain/entity/address_entity.dart';
import '../datasource/remote/model/address_api_model.dart';

extension AddressApiModelMapping on AddressApiModel {
  AddressEntity toAddressEntity() {
    return AddressEntity(
      placeId: placeId ?? 0,
      latitude: double.tryParse(lat ?? '0.0') ?? 0.0,
      longitude: double.tryParse(lon ?? '0.0') ?? 0.0,
      displayName: displayName ?? '',
    );
  }
}
