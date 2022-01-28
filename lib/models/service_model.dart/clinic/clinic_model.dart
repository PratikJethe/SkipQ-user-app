import 'package:skipq/constants/globals.dart';
import 'package:skipq/models/api_response_model.dart';
import 'package:skipq/models/general_model/contact_model.dart';
import 'package:skipq/models/service_model.dart/clinic/clinic_address_model.dart';
import 'package:skipq/models/service_model.dart/clinic/clinic_token_model.dart';
import 'package:skipq/service/clinic/clinic_service.dart';
import 'package:skipq/utils/date_converter.dart';
import 'package:skipq/utils/json_converters.dart';
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
  @JsonKey(name: 'dateOfBirth', fromJson: utcToLocalOptional)
  DateTime? dob;
  bool isVerified;
  List<String> speciality;

  bool hasClinicStarted;

  //Provider Retaed Properties

  @JsonKey(ignore: true)
  bool isLoadingTokens = false;
  @JsonKey(ignore: true)
  List<ClinicToken> clinicPendingTokenList = [];

  ClinicService _clinicService = ClinicService();

  Clinic({
    required this.id,
    required this.clinicName,
    required this.authProvider,
    required this.fcm,
    required this.doctorName,
    required this.hasClinicStarted,
    required this.isVerified,
    required this.speciality,
    required this.address,
    required this.contact,
    this.gender,
    this.about,
    this.notice,
    this.email,
    this.profilePicUrl,
    this.dob,
  });

// SERIALIZABLE LOGIC
  factory Clinic.fromJson(Map<String, dynamic> json) => _$ClinicFromJson(json);
  Map<String, dynamic> toJson() => _$ClinicToJson(this);

// PROVIDER LOGIC

  @JsonKey(ignore: true)
  bool hasTokenError = false;

  set setisTokenLoading(bool value) {
    isLoadingTokens = value;
    notifyListeners();
  }

  getPendingTokens({bool? showLoading}) async {
    if (showLoading == true) {
      setisTokenLoading = true;
    }
    hasTokenError = false;
    ServiceResponse serviceResponse = await _clinicService.getPendingToken(id);
    setisTokenLoading = false;

    clinicPendingTokenList.clear();

    print(serviceResponse.data);
    if (serviceResponse.apiResponse.error) {
      hasTokenError = true;
      isLoadingTokens = false;
      return;
    }
    clinicPendingTokenList.addAll(serviceResponse.data);
  }

  Future<ServiceResponse> requestToken() async {
    ServiceResponse serviceResponse = await _clinicService.requestToken(id);

    return serviceResponse;
  }

  Future<ServiceResponse> cancelRequest(String tokenId) async {
    ServiceResponse serviceResponse = await _clinicService.cancelRequest(tokenId);

    return serviceResponse;
  }

  Future<ServiceResponse> cancelToken(String tokenId) async {
    ServiceResponse serviceResponse = await _clinicService.cancelToken(tokenId);

    return serviceResponse;
  }
}
