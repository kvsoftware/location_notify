// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressApiModel _$AddressApiModelFromJson(Map<String, dynamic> json) =>
    AddressApiModel(
      placeId: json['place_id'] as int?,
      lat: json['lat'] as String?,
      lon: json['lon'] as String?,
      displayName: json['display_name'] as String?,
      address: json['address'] == null
          ? null
          : AddressSubApiModel.fromJson(
              json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AddressApiModelToJson(AddressApiModel instance) =>
    <String, dynamic>{
      'place_id': instance.placeId,
      'lat': instance.lat,
      'lon': instance.lon,
      'display_name': instance.displayName,
      'address': instance.address,
    };

AddressSubApiModel _$AddressSubApiModelFromJson(Map<String, dynamic> json) =>
    AddressSubApiModel(
      road: json['road'] as String?,
      neighbourhood: json['neighbourhood'] as String?,
      suburb: json['suburb'] as String?,
      city: json['city'] as String?,
      county: json['county'] as String?,
      iSO31662Lvl6: json['iSO31662Lvl6'] as String?,
      state: json['state'] as String?,
      iSO31662Lvl4: json['iSO31662Lvl4'] as String?,
      postcode: json['postcode'] as String?,
      country: json['country'] as String?,
      countryCode: json['countryCode'] as String?,
    );

Map<String, dynamic> _$AddressSubApiModelToJson(AddressSubApiModel instance) =>
    <String, dynamic>{
      'road': instance.road,
      'neighbourhood': instance.neighbourhood,
      'suburb': instance.suburb,
      'city': instance.city,
      'county': instance.county,
      'iSO31662Lvl6': instance.iSO31662Lvl6,
      'state': instance.state,
      'iSO31662Lvl4': instance.iSO31662Lvl4,
      'postcode': instance.postcode,
      'country': instance.country,
      'countryCode': instance.countryCode,
    };
