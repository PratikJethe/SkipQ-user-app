import 'dart:io';

import 'package:booktokenapp/main.dart';
import 'package:booktokenapp/models/api_response_model.dart';
import 'package:booktokenapp/models/user_model.dart';
import 'package:booktokenapp/screens/authentication/login_screen.dart';
import 'package:booktokenapp/screens/authentication/registration_screen.dart';
import 'package:booktokenapp/screens/homepage/homepage.dart';
import 'package:booktokenapp/service/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserProvider extends ChangeNotifier {
  late User user;
  ApiService _apiService = getIt.get<ApiService>();
  bool isAuthenticated = false;
  bool triedFetchingUser = false;

  Future getUser(BuildContext context) async {
    List<Cookie> cookiesList = await _apiService.getCookies();
    if (cookiesList.length == 0) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
      return;
    }
    ApiResponse response = await _apiService.get('/user/auth/get-by-id');
    if (!response.error) {
      user = User.fromJson(response.data);
      isAuthenticated = true;
      triedFetchingUser = true;
      print(user.toJson().toString());
      notifyListeners();
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      print(response);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
    }
  }

  phoneLogin(Map<String, dynamic> payload, BuildContext context) async {
    var response = await _apiService.post('/user/auth/phone-login', payload);

    print(response.errMsg);
    if (!response.error) {
      user = User.fromJson(response.data);
      isAuthenticated = true;
      triedFetchingUser = true;
      print(user.toJson().toString());
      notifyListeners();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
    } else {
      print(response);
      if (response.statusCode == 404) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => RegistrationScreen(
                  uid: payload["uid"],
                  mobileNumber: payload["phoneNo"],
                )));
        return;
      }
      Fluttertoast.showToast(
          msg: response.errMsg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 2, fontSize: 16.0);
    }
  }

  register(Map<String, dynamic> payload, BuildContext context) async {
    print(payload);
    var response = await _apiService.post('/user/auth/register', payload);

    print(response.errMsg);
    if (!response.error) {
      user = User.fromJson(response.data);
      isAuthenticated = true;
      triedFetchingUser = true;
      print(user.toJson().toString());
      notifyListeners();
      print(user.toString());
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
    } else {
      print(response);
      Fluttertoast.showToast(
          msg: "${response.errMsg}", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 2, fontSize: 16.0);
    }
  }
}
