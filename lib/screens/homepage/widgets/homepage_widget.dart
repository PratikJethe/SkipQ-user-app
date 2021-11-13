import 'package:booktokenapp/providers/user_provider.dart';
import 'package:booktokenapp/widgets/search_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageWidget extends StatefulWidget {
  final int currentIndex;
  final Function changeCurrentIndex;
  const HomePageWidget({Key? key, required this.currentIndex,required this.changeCurrentIndex}) : super(key: key);

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
              currentIndex: widget.currentIndex,
              changeCurrentIndex: widget.changeCurrentIndex,
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
