import 'package:booktokenapp/main.dart';
import 'package:booktokenapp/models/user_model.dart';
import 'package:booktokenapp/screens/authentication/login_screen.dart';
import 'package:booktokenapp/screens/homepage/homepage.dart';
import 'package:booktokenapp/service/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User user = User();
  ApiService _apiService = getIt.get<ApiService>();
  bool isAuthenticated = false;
  bool triedFetchingUser = false;

  //   User get user => _user;

  // set user(User user) {
  //   _user = user;
  // }

  // set isAuthenticated(bool isAuthenticated) {
  //   _isAuthenticated = isAuthenticated;
  // }

  getUser(BuildContext context) async {
    var cookiesList = await _apiService.getCookies();
    if (cookiesList.length == 0) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
      return;
    }

    var response = await _apiService.get('/user/auth/get-by-id');

    if (!response['error']) {
      user = User.fromJson(response["data"]);
      isAuthenticated = true;
      triedFetchingUser = true;
      print(user.toJson().toString());
      notifyListeners();
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      print(response);
    }
  }

  phoneLogin(int phoneNo, BuildContext context) async {
    var response = await _apiService.post('/user/auth/phone-login', {"phoneNo": phoneNo});

    print(response);
    if (!response['error']) {
      user = User.fromJson(response["data"]);
      isAuthenticated = true;
      notifyListeners();
    } else {
      print(response);
    }
  }
}
