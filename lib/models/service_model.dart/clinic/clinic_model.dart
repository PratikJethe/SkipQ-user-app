import 'package:booktokenapp/constants/globals.dart';
import 'package:booktokenapp/models/api_response_model.dart';
import 'package:booktokenapp/models/general_model/contact_model.dart';
import 'package:booktokenapp/models/service_model.dart/clinic/clinic_address_model.dart';
import 'package:booktokenapp/models/service_model.dart/clinic/clinic_token_model.dart';
import 'package:booktokenapp/service/clinic/clinic_service.dart';
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
    notifyListeners();
  }

  getPendingTokens() async {
    clinicPendingTokenList.clear();
    setisTokenLoading = true;
    ServiceResponse serviceResponse = await _clinicService.getPendingToken(id);
    setisTokenLoading = false;

    print(serviceResponse.data);
    if (serviceResponse.apiResponse.error) {
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
