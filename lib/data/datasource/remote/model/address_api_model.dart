import 'package:json_annotation/json_annotation.dart';

part 'address_api_model.g.dart';

@JsonSerializable()
class AddressApiModel {
  @JsonKey(name: 'place_id')
  int? placeId;
  String? lat;
  String? lon;
  @JsonKey(name: 'display_name')
  String? displayName;
  AddressSubApiModel? address;

  AddressApiModel({
    this.placeId,
    this.lat,
    this.lon,
    this.displayName,
    this.address,
  });

  factory AddressApiModel.fromJson(Map<String, dynamic> json) => _$AddressApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressApiModelToJson(this);
}

@JsonSerializable()
class AddressSubApiModel {
  String? road;
  String? neighbourhood;
  String? suburb;
  String? city;
  String? county;
  String? iSO31662Lvl6;
  String? state;
  String? iSO31662Lvl4;
  String? postcode;
  String? country;
  String? countryCode;

  AddressSubApiModel({
    this.road,
    this.neighbourhood,
    this.suburb,
    this.city,
    this.county,
    this.iSO31662Lvl6,
    this.state,
    this.iSO31662Lvl4,
    this.postcode,
    this.country,
    this.countryCode,
  });

  factory AddressSubApiModel.fromJson(Map<String, dynamic> json) => _$AddressSubApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressSubApiModelToJson(this);
}
