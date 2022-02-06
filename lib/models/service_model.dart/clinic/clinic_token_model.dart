import 'dart:developer';

import 'package:skipq/constants/globals.dart';
import 'package:skipq/models/service_model.dart/clinic/clinic_model.dart';
import 'package:skipq/models/user_model.dart';
import 'package:skipq/utils/date_converter.dart';
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
  int? tokenNumber;
  TokenStatus tokenStatus;
  UserType userType;
  @JsonKey(fromJson: utcToLocal)
  DateTime createdAt;
  @JsonKey(fromJson: utcToLocal)
  DateTime updatedAt;

  bool get isOnline {
    return userType == UserType.ONLINE;
  }

  ClinicToken(
      {required this.id,
      required this.clinic,
      required this.createdAt,
      required this.tokenStatus,
      required this.updatedAt,
      this.tokenNumber,
      required this.userType,
      this.user});

  factory ClinicToken.fromJson(Map<String, dynamic> json) => _$ClinicTokenFromJson(json);
  Map<String, dynamic> toJson() => _$ClinicTokenToJson(this);
}
