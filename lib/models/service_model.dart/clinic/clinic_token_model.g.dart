// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClinicToken _$ClinicTokenFromJson(Map<String, dynamic> json) => ClinicToken(
      id: json['_id'] as String,
      clinic: Clinic.fromJson(json['clinicId'] as Map<String, dynamic>),
      createdAt: utcToLocal(json['createdAt'] as String),
      tokenStatus: $enumDecode(_$TokenStatusEnumMap, json['tokenStatus']),
      updatedAt: utcToLocal(json['updatedAt'] as String),
      tokenNumber: json['tokenNumber'] as int?,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
      user: json['userId'] == null
          ? null
          : User.fromJson(json['userId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClinicTokenToJson(ClinicToken instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'clinicId': instance.clinic,
      'userId': instance.user,
      'tokenNumber': instance.tokenNumber,
      'tokenStatus': _$TokenStatusEnumMap[instance.tokenStatus],
      'userType': _$UserTypeEnumMap[instance.userType],
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$TokenStatusEnumMap = {
  TokenStatus.REQUESTED: 'REQUESTED',
  TokenStatus.CANCELLED_REQUESTED: 'CANCELLED_REQUESTED',
  TokenStatus.REJECTED_REQUEST: 'REJECTED_REQUEST',
  TokenStatus.PENDING_TOKEN: 'PENDING_TOKEN',
  TokenStatus.CANCELLED_TOKEN: 'CANCELLED_TOKEN',
  TokenStatus.REJECTED_TOKEN: 'REJECTED_TOKEN',
  TokenStatus.COMPLETED_TOKEN: 'COMPLETED_TOKEN',
};

const _$UserTypeEnumMap = {
  UserType.ONLINE: 'ONLINE',
  UserType.OFFLINE: 'OFFLINE',
};
