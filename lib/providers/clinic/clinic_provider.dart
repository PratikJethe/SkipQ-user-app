import 'dart:convert';

import 'package:booktokenapp/main.dart';
import 'package:booktokenapp/models/api_response_model.dart';
import 'package:booktokenapp/models/service_model.dart/clinic/clinic_model.dart';
import 'package:booktokenapp/models/service_model.dart/clinic/clinic_token_model.dart';
import 'package:booktokenapp/service/api_service.dart';
import 'package:booktokenapp/service/clinic/clinic_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ClinicSearchMode { TEXT, LOCATION }

class ClinicProvider extends ChangeNotifier {
  List<Clinic> searchedClinicList = [];
  List<ClinicToken> clinicPendingTokenList = [];
  ApiService _apiService = getIt.get<ApiService>();
  ClinicService _clinicService = ClinicService();

  ClinicSearchMode clinicSearchMode = ClinicSearchMode.TEXT;

  List<ClinicToken> userTokenList = [];

  bool searchLoading = false;
  bool searchError = false;
  bool isUserTokenLoading = false;
  bool hasErrorUserTokenLoading = false;
  bool hasSearchedClinic = false;

  int searchPageNo = 0;
  String serachKeyword = '';
  late double storedLattitude;
  late double storedLongitude;
  set setIsUserTokenLoading(value) {
    isUserTokenLoading = value;
    notifyListeners();
  }

  set serachString(value) {
    serachKeyword = value;
    print(serachKeyword);
  }

  set latlng(List latlng) {
    storedLattitude = latlng[0];
    storedLongitude = latlng[1];
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

  resetSearch(ClinicSearchMode searchMode) {
    searchLoading = false;
    searchPageNo = 0;
    searchedClinicList.clear();
    hasSearchedClinic = false;
    clinicSearchMode = searchMode;
  }

  Future searchClinic(String keyword, {isPaginating}) async {
    hasSearchedClinic = true;
    // searchedClinicList.clear();
    setSearchError = false;
    setSearchLoading = true;
    ServiceResponse serviceResponse = await _clinicService.searchClinic(keyword, searchPageNo);
    setSearchLoading = false;

    if (serviceResponse.apiResponse.error) {
      setSearchError = true;
      setSearchLoading = false;
      return;
    }
    if (serviceResponse.data.length != 0) {
      searchPageNo++;
    }
    searchedClinicList.addAll(serviceResponse.data);
  }

  Future searchNearByClinic(double lattitude, double longitude, {isPaginating}) async {
    hasSearchedClinic = true;
    // searchedClinicList.clear();
    setSearchError = false;
    setSearchLoading = true;
    ServiceResponse serviceResponse = await _clinicService.searchNearByClinic(lattitude, longitude, searchPageNo);
    setSearchLoading = false;
    if (serviceResponse.apiResponse.error) {
      setSearchError = true;
      setSearchLoading = false;
      return;
    }
    if (serviceResponse.data.length != 0) {
      searchPageNo++;
    }
    searchedClinicList.addAll(serviceResponse.data);
  }

  Future<ServiceResponse> getUserToken() async {
    setIsUserTokenLoading = true;
    setHasErrorUserTokenLoading = false;

    ApiResponse apiResponse = await _apiService.get("/clinic/queue/get-user-tokens");

    if (apiResponse.error) {
      setHasErrorUserTokenLoading = true;
      setIsUserTokenLoading = false;
      print('ERRRORRR');
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
