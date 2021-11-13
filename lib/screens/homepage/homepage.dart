import 'package:booktokenapp/providers/user_provider.dart';
import 'package:booktokenapp/screens/homepage/widgets/bottom_navigation_bar.dart';
import 'package:booktokenapp/screens/homepage/widgets/homepage_widget.dart';
import 'package:booktokenapp/screens/search/search_screen.dart';
import 'package:booktokenapp/widgets/search_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  onTap(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigationBar(currentIndex, onTap),
      body: SafeArea(
        child: Consumer<UserProvider>(builder: (context, userProvider, _) {
          if (currentIndex == 0) {
            return HomePageWidget(
              currentIndex: currentIndex,
              changeCurrentIndex: onTap,
            );
          } else if (currentIndex == 1) {
            return SearchScreen(currentIndex: currentIndex, changeCurrentIndex: onTap);
          } else if (currentIndex == 2) {
            return Container(
              child: Text('3'),
            );
          } else {
            return Container(
              child: Text('4'),
            );
          }
        }),
      ),
    );
  }
}
