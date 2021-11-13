import 'package:booktokenapp/main.dart';
import 'package:booktokenapp/models/api_response_model.dart';
import 'package:booktokenapp/models/service_model.dart/clinic/clinic_model.dart';
import 'package:booktokenapp/service/api_service.dart';
import 'package:booktokenapp/service/clinic/clinic_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClinicProvider extends ChangeNotifier {
  List<Clinic> searchedClinicList = [];
  ApiService _apiService = getIt.get<ApiService>();
  ClinicService _clinicService = ClinicService();

  bool searchLoading = false;
  bool searchError = false;
  bool hasSearchedClinic = false;

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
}
