import 'package:launch_review/launch_review.dart';
import 'package:skipq/config/app_config.dart';
import 'package:skipq/providers/user_provider.dart';
import 'package:skipq/screens/privarcy/privarcy_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../main.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  AppConfig _appConfig = getIt.get<AppConfig>();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.7,
        child: ListView(
          children: [
            // ListTile(
            //   leading: Icon(Icons.settings),
            //   title: Text('Settings'),
            //   onTap: () async {
            //     await userProvider.logout(context);
            //   },
            // ),
            
            // ListTile(
            //   leading: Icon(Icons.question_answer),
            //   title: Text('Faq'),
            //   onTap: () async {
            //     await userProvider.logout(context);
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share app'),
              onTap: () async {
                Share.share(
                    'check out this app which helps you to book token online from your local doctor \n https://play.google.com/store/apps/details?id=${_appConfig.androidAppId}');
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              onTap: () async {
                final Email email = Email(
                  recipients: [_appConfig.helpEmail],
                  isHTML: false,
                );

                await FlutterEmailSender.send(email);
              },
            ),
            ListTile(
              leading: Icon(Icons.thumb_up),
              title: Text('Rate us'),
              onTap: () async {
                LaunchReview.launch(androidAppId: _appConfig.androidAppId);
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip_rounded),
              title: Text('Privacy Policy'),
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrivarcyPolicy()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log out'),
              onTap: () async {
                await userProvider.logout(context);
              },
            ),
          ],
        ),
      );
    });
  }
}
