// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Clinic _$ClinicFromJson(Map<String, dynamic> json) => Clinic(
      id: json['_id'] as String,
      clinicName: json['clinicName'] as String,
      authProvider: json['authProvider'] as String,
      fcm: json['fcm'] as String,
      doctorName: json['doctorName'] as String,
      hasClinicStarted: json['hasClinicStarted'] as bool,
      isSubscribed: json['isSubscribed'] as bool,
      isVerified: json['isVerified'] as bool,
      speciality: (json['speciality'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      subEndDate: DateTime.parse(json['subEndDate'] as String),
      subStartDate: DateTime.parse(json['subStartDate'] as String),
      address: ClinicAddress.fromJson(json['address'] as Map<String, dynamic>),
      contact: Contact.fromJson(json['contact'] as Map<String, dynamic>),
      about: json['about'] as String?,
      notice: json['notice'] as String?,
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      email: json['email'] as String?,
      profilePicUrl: json['profilePicUrl'] as String?,
      dob: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
    );

Map<String, dynamic> _$ClinicToJson(Clinic instance) => <String, dynamic>{
      '_id': instance.id,
      'doctorName': instance.doctorName,
      'clinicName': instance.clinicName,
      'authProvider': instance.authProvider,
      'fcm': instance.fcm,
      'address': instance.address,
      'gender': _$GenderEnumMap[instance.gender],
      'email': instance.email,
      'contact': instance.contact,
      'profilePicUrl': instance.profilePicUrl,
      'about': instance.about,
      'notice': instance.notice,
      'dateOfBirth': instance.dob?.toIso8601String(),
      'isVerified': instance.isVerified,
      'speciality': instance.speciality,
      'isSubscribed': instance.isSubscribed,
      'subStartDate': instance.subStartDate.toIso8601String(),
      'subEndDate': instance.subEndDate.toIso8601String(),
      'hasClinicStarted': instance.hasClinicStarted,
    };

const _$GenderEnumMap = {
  Gender.MALE: 'MALE',
  Gender.FEMALE: 'FEMALE',
  Gender.OTHER: 'OTHER',
  Gender.NONE: 'NONE',
};
