// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClinicAddress _$ClinicAddressFromJson(Map<String, dynamic> json) =>
    ClinicAddress(
      address: json['address'] as String,
      apartment: json['apartment'] as String?,
      coordinates:
          coordinatesFromJson(json['geometry'] as Map<String, dynamic>),
      pincode: json['pincode'] as String?,
      city: json['city'] as String,
    );

Map<String, dynamic> _$ClinicAddressToJson(ClinicAddress instance) =>
    <String, dynamic>{
      'address': instance.address,
      'apartment': instance.apartment,
      'city': instance.city,
      'pincode': instance.pincode,
      'geometry': instance.coordinates,
    };
