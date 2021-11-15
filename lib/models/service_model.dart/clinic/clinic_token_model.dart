import 'dart:developer';

import 'package:booktokenapp/constants/globals.dart';
import 'package:booktokenapp/models/service_model.dart/clinic/clinic_model.dart';
import 'package:booktokenapp/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clinic_token_model.g.dart';

@JsonSerializable()
class ClinicToken {
  @JsonKey(name: '_id')
  String id;
  @JsonKey(name: 'clinicId')
  Clinic clinic;
  @JsonKey(name: 'userId')
  User? user;
  TokenStatus tokenStatus;
  UserType userType;
  DateTime createdAt;
  DateTime updatedAt;

  bool get isOnline { return userType == UserType.ONLINE;}

  ClinicToken({
    required this.id,
    required this.clinic,
    required this.createdAt,
    required this.tokenStatus,
    required this.updatedAt,
    required this.userType,
    this.user
  });

  factory ClinicToken.fromJson(Map<String, dynamic> json) => _$ClinicTokenFromJson(json);
  Map<String, dynamic> toJson() => _$ClinicTokenToJson(this);
}