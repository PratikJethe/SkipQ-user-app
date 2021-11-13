import 'package:booktokenapp/constants/globals.dart';
import 'package:booktokenapp/models/general_model/contact_model.dart';
import 'package:booktokenapp/models/service_model.dart/clinic/clinic_address_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:json_annotation/json_annotation.dart';
part 'clinic_model.g.dart';

@JsonSerializable()
class Clinic extends ChangeNotifier {
  @JsonKey(name: '_id')
  String id;
  String doctorName;
  String clinicName;
  String authProvider;
  String fcm;
  ClinicAddress address;
  Gender? gender;
  String? email;
  Contact contact;
  String? profilePicUrl;
  String? about;
  String? notice;
  @JsonKey(name: 'dateOfBirth')
  DateTime? dob;
  bool isVerified;
  List<String> speciality;
  bool isSubscribed;
  DateTime subStartDate;
  DateTime subEndDate;
  bool hasClinicStarted;

  //Provider Retaed Properties

  @JsonKey(ignore: true)
  bool isLoadingTokens = false;

  Clinic({
    required this.id,
    required this.clinicName,
    required this.authProvider,
    required this.fcm,
    required this.doctorName,
    required this.hasClinicStarted,
    required this.isSubscribed,
    required this.isVerified,
    required this.speciality,
    required this.subEndDate,
    required this.subStartDate,
    required this.address,
    required this.contact,
    this.about,
    this.notice,
    this.gender,
    this.email,
    this.profilePicUrl,
    this.dob,
  });

// SERIALIZABLE LOGIC
  factory Clinic.fromJson(Map<String, dynamic> json) => _$ClinicFromJson(json);
  Map<String, dynamic> toJson() => _$ClinicToJson(this);

// PROVIDER LOGIC
  set setisTokenLoading(bool value) {
    isLoadingTokens = value;
  }

}
