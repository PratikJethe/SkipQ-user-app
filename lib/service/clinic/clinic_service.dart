import 'package:booktokenapp/main.dart';
import 'package:booktokenapp/models/api_response_model.dart';
import 'package:booktokenapp/models/service_model.dart/clinic/clinic_model.dart';
import 'package:booktokenapp/service/api_service.dart';

class ClinicService {
  ApiService _apiService = getIt.get<ApiService>();

  Future<ServiceResponse> searchClinic(String keyword) async {
    ApiResponse apiResponse = await _apiService.get("/clinic/profile/search-by-keyword?keyword=$keyword");

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: apiResponse.data.map<Clinic>((e) {
      print(e);
      return Clinic.fromJson(e);
    }));
  }

  Future<ServiceResponse> getClinicProfile(String id) async {
    ApiResponse apiResponse = await _apiService.get("/clinic/profile/$id");

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: Clinic.fromJson(apiResponse.data));
  }
}
