import 'package:booktokenapp/providers/user_provider.dart';
import 'package:booktokenapp/widgets/search_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageWidget extends StatefulWidget {
  
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      return Container(
        child: Column(
          children: [
            SearchAppBar(
             
            ),
            Center(
                child: TextButton(
              child: Text('HomePage'),
              onPressed: () {
                userProvider.logout(context);
              },
            )),
          ],
        ),
      );
    });
  }
}
