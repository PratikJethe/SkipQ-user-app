import 'package:booktokenapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.7,
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () async {
                await userProvider.logout(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip_rounded),
              title: Text('Privarcy Policy'),
              onTap: () async {
                await userProvider.logout(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text('Faq'),
              onTap: () async {
                await userProvider.logout(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share app'),
              onTap: () async {
                await userProvider.logout(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              onTap: () async {
                await userProvider.logout(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.thumb_up),
              title: Text('Rate us'),
              onTap: () async {
                await userProvider.logout(context);
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
