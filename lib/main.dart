import 'package:booktokenapp/providers/clinic/clinic_provider.dart';
import 'package:booktokenapp/providers/user_provider.dart';
import 'package:booktokenapp/screens/splash_screen/splash_screen.dart';
import 'package:booktokenapp/service/api_service.dart';
import 'package:booktokenapp/service/firebase_services/auth_service.dart';
import 'package:booktokenapp/service/firebase_services/fcm_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerLazySingleton(() => ApiService());
  getIt.registerLazySingleton(() => FirebaseAuthService());
  getIt.registerLazySingleton(() => FcmService());
  await getIt.get<ApiService>().addCookieInceptor();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => ClinicProvider()),
        ],
        child: MaterialApp(
          title: 'BookToken',
          theme: ThemeData(
            fontFamily: 'Lato',
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen(),
        ));
  }
}
