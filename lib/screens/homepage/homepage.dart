import 'package:booktokenapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BookTokenUser')),
      body: Consumer<UserProvider>(builder: (context, userProvider, _) {
        return Container(
          child: Center(
              child: TextButton(
            child: Text('HomePage'),
            onPressed: () {
              userProvider.logout(context);
            },
          )),
        );
      }),
    );
  }
}
