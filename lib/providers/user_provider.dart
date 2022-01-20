import 'dart:io';

import 'package:booktokenapp/main.dart';
import 'package:booktokenapp/models/api_response_model.dart';
import 'package:booktokenapp/models/user_model.dart';
import 'package:booktokenapp/screens/authentication/login_screen.dart';
import 'package:booktokenapp/screens/authentication/registration_screen.dart';
import 'package:booktokenapp/screens/homepage/homepage.dart';
import 'package:booktokenapp/service/api_service.dart';
import 'package:booktokenapp/service/user/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

class UserProvider extends ChangeNotifier {
  late User user;
  ApiService _apiService = getIt.get<ApiService>();
  UserService _userService = UserService();
  bool isAuthenticated = false;
  bool showModalLoading = false;
  int bottomNavIndex = 0;

  set setBottomNavIndex(index) {
    if (bottomNavIndex != index) {
      bottomNavIndex = index;
      notifyListeners();
    }
  }

  set setShowModalLoading(value) {
    showModalLoading = value;
    notifyListeners();
  }

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
      print(user.toJson().toString());
      notifyListeners();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
    } else {
      print(response);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
    }
  }

  phoneLogin(Map<String, dynamic> payload, BuildContext context) async {
    // try {
    //   var response = AllInOneSdk.startTransaction('OdCdmt83472104874643', 'ORDER_ID_1636287501923', '1.00',
    //       '6d7feb419c1e4162853eca6d6686c7661636287500177', "https://webhook.site/64c2017e-201c-46b0-a886-51812a4622fe", true, true);
    //   response.then((value) {
    //     print(value);
    //   }).catchError((onError) {
    //     if (onError is PlatformException) {
    //       print(onError);
    //     } else {}
    //   });
    // } catch (err) {
    //   print(err);
    // }

    var response = await _apiService.post('/user/auth/phone-login', payload);

    print(response.errMsg);
    if (!response.error) {
      user = User.fromJson(response.data);
      isAuthenticated = true;
      print(user.toJson().toString());
      notifyListeners();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
    } else {
      print(response);
      if (response.statusCode == 404) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => RegistrationScreen(uid: payload["uid"], mobileNumber: payload["phoneNo"])));
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

  Future logout(BuildContext context) async {
    _apiService.clearCookies().then((value) {
      isAuthenticated = false;
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: "Failed to logout", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 2, fontSize: 16.0);
    });
  }

  Future<ServiceResponse> updateUser(userDeatils) async {
    ServiceResponse serviceResponse = await _userService.updateProfile(userDeatils);
    if (serviceResponse.apiResponse.error) {
      return serviceResponse;
    }

    user = serviceResponse.data;
    print(user.toString());
    notifyListeners();

    return serviceResponse;
  }
}
