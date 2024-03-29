import 'package:skipq/main.dart';
import 'package:skipq/models/api_response_model.dart';
import 'package:skipq/models/user_model.dart';
import 'package:skipq/service/api_service.dart';

class UserService {
  ApiService _apiService = getIt.get<ApiService>();

  Future<ServiceResponse> updateProfile(data) async {
    ApiResponse apiResponse = await _apiService.post("/user/profile/update-profile", data);

    print('Error Msg');
    print(apiResponse.errMsg);

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: User.fromJson(apiResponse.data));
  }
}
