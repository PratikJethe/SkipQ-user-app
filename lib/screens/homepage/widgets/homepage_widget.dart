import 'package:booktokenapp/providers/user_provider.dart';
import 'package:booktokenapp/resources/resources.dart';
import 'package:booktokenapp/service/firebase_services/fcm_service.dart';
import 'package:booktokenapp/widgets/search_appbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    // you get data when app is in background or foreground state
    FirebaseMessaging.onMessage.listen(onBackgroundMessage);

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    //terminated state
    // FirebaseMessaging.instance.getInitialMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      return Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SearchAppBar(),
              Expanded(
                  child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InfoTile(path: 'queue.png', title: 'Tiered of waiting in a clinic queue? Now book token online from home.'),
                    InfoTile(path: 'search.png', title: 'Select doctor based on Location, Address, city and Speciality'),
                    InfoTile(path: 'notification-small.png', title: 'Get real time update on your phone. Leave home when notified.'),
                  ],
                ),
              ))
            ],
          ),
        ),
      );
    });
  }
}

class InfoTile extends StatelessWidget {
  final String path;
  final String title;

  const InfoTile({Key? key, required this.path, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      child: Container(
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Container(
              // height: MediaQuery.of(context).size.height * 0.3,
              child: Image.asset(
                'assets/images/${path}',
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.3,
                // fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              width: 25,
            ),
            Expanded(
              child: Text(
                title,
                softWrap: true,
                style: R.styles.fz18Fw500.merge(R.styles.fontColorBluishGrey),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
