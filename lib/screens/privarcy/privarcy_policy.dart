import 'package:skipq/config/app_config.dart';
import 'package:skipq/main.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivarcyPolicy extends StatefulWidget {
  const PrivarcyPolicy({Key? key}) : super(key: key);

  @override
  _PrivarcyPolicyState createState() => _PrivarcyPolicyState();
}

class _PrivarcyPolicyState extends State<PrivarcyPolicy> {
  AppConfig _appConfig = getIt.get<AppConfig>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: '${_appConfig.endPoint}/user/profile/privarcy-policy',
      ),
    );
  }
}
