import 'package:skipq/main.dart';
import 'package:skipq/models/api_response_model.dart';
import 'package:skipq/models/service_model.dart/clinic/clinic_model.dart';
import 'package:skipq/models/service_model.dart/clinic/clinic_token_model.dart';
import 'package:skipq/service/api_service.dart';

class ClinicService {
  ApiService _apiService = getIt.get<ApiService>();

  Future<ServiceResponse> searchClinic(String keyword, pageNo) async {
    ApiResponse apiResponse = await _apiService.get("/clinic/profile/search-by-keyword?keyword=$keyword&pageNo=$pageNo");

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: apiResponse.data.map<Clinic>((e) {
      print('here');
      print(e);
      return Clinic.fromJson(e);
    }));
  }

  Future<ServiceResponse> searchNearByClinic(double lattitude, double longitude, int pageNo) async {
    ApiResponse apiResponse = await _apiService.get("/clinic/profile/search-by-location?lattitude=$lattitude&longitude=$longitude=&pageNo=$pageNo");

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: apiResponse.data.map<Clinic>((e) {
      print('here');
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

  Future<ServiceResponse> getPendingToken(String id) async {
    ApiResponse apiResponse = await _apiService.get("/clinic/queue/get-pending-tokens/$id");

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: apiResponse.data.map<ClinicToken>((e) {
      return ClinicToken.fromJson(e);
    }));
  }

  Future<ServiceResponse> getUserToken() async {
    ApiResponse apiResponse = await _apiService.get("/clinic/queue/get-user-tokens");

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }
    print(apiResponse.data);
    return ServiceResponse(apiResponse, data: apiResponse.data.map<ClinicToken>((e) {
      return ClinicToken.fromJson(e);
    }));
  }

  //

  Future<ServiceResponse> requestToken(String id) async {
    ApiResponse apiResponse = await _apiService.post("/clinic/queue/request-token", {'clinicId': id});

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }
    print(apiResponse.data);
    return ServiceResponse(apiResponse, data: ClinicToken.fromJson(apiResponse.data));
  }

  Future<ServiceResponse> cancelRequest(String id) async {
    ApiResponse apiResponse = await _apiService.post("/clinic/queue/cancel-request", {'tokenId': id});

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }
    print(apiResponse.data);
    return ServiceResponse(apiResponse, data: ClinicToken.fromJson(apiResponse.data));
  }

  Future<ServiceResponse> cancelToken(String id) async {
    ApiResponse apiResponse = await _apiService.post("/clinic/queue/cancel-token", {'tokenId': id});

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }
    print(apiResponse.data);
    return ServiceResponse(apiResponse, data: ClinicToken.fromJson(apiResponse.data));
  }
}
