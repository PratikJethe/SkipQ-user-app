import 'package:booktokenapp/main.dart';
import 'package:booktokenapp/models/api_response_model.dart';
import 'package:booktokenapp/models/service_model.dart/clinic/clinic_model.dart';
import 'package:booktokenapp/models/service_model.dart/clinic/clinic_token_model.dart';
import 'package:booktokenapp/service/api_service.dart';
import 'package:booktokenapp/service/clinic/clinic_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClinicProvider extends ChangeNotifier {
  List<Clinic> searchedClinicList = [];
  List<ClinicToken> clinicPendingTokenList = [];
  ApiService _apiService = getIt.get<ApiService>();
  ClinicService _clinicService = ClinicService();

  List<ClinicToken> userTokenList = [];

  bool searchLoading = false;
  bool searchError = false;
  bool isUserTokenLoading = false;
  bool hasErrorUserTokenLoading = false;
  bool hasSearchedClinic = false;

  set setIsUserTokenLoading(value) {
    isUserTokenLoading = value;
    notifyListeners();
  }

  set setHasErrorUserTokenLoading(value) {
    hasErrorUserTokenLoading = value;
    notifyListeners();
  }

  set setSearchLoading(value) {
    searchLoading = value;
    notifyListeners();
  }

  set setSearchError(value) {
    searchLoading = value;
    notifyListeners();
  }

  searchClinic(String keyword) async {
    hasSearchedClinic = true;
    searchedClinicList.clear();
    setSearchError = false;
    setSearchLoading = true;
    ServiceResponse serviceResponse = await _clinicService.searchClinic(keyword);
    setSearchLoading = false;

  

    if (serviceResponse.apiResponse.error) {
      setSearchError = true;
      setSearchLoading = false;
      return;
    }

    searchedClinicList.addAll(serviceResponse.data);
  }

  Future<ServiceResponse> getUserToken() async {

    setIsUserTokenLoading = true;
    ApiResponse apiResponse = await _apiService.get("/clinic/queue/get-user-tokens");

    if (apiResponse.error) {
      setHasErrorUserTokenLoading = true;
      setIsUserTokenLoading = false;

      return ServiceResponse(apiResponse);
    }
    ServiceResponse serviceResponse = ServiceResponse(apiResponse, data: apiResponse.data.map<ClinicToken>((e) {
      return ClinicToken.fromJson(e);
    }));

    userTokenList.clear();
    userTokenList.addAll(serviceResponse.data!.toList());
    setIsUserTokenLoading = false;

    notifyListeners();
    return serviceResponse;
  }
}
