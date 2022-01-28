import 'package:skipq/providers/user_provider.dart';
import 'package:skipq/screens/homepage/widgets/bottom_navigation_bar.dart';
import 'package:skipq/screens/homepage/widgets/homepage_widget.dart';
import 'package:skipq/screens/modal-screen/modal_loading_screen.dart';
import 'package:skipq/screens/my_tokens/clinic_user_tokens.dart';
import 'package:skipq/screens/profile/profile_screen.dart';
import 'package:skipq/screens/search/search_screen.dart';
import 'package:skipq/widgets/search_appbar.dart';
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
    return ModalLoadingScreen(
      child: Scaffold(
        bottomNavigationBar: bottomNavigationBar(context),
        body: SafeArea(
          child: Consumer<UserProvider>(builder: (context, userProvider, _) {
            int currentIndex = userProvider.bottomNavIndex;

            print('gender');
            print(userProvider.user.gender);
            if (currentIndex == 0) {
              return HomePageWidget();
            } else if (currentIndex == 1) {
              return SearchScreen();
            } else if (currentIndex == 2) {
              return ClinicUserToken(showAppbar: true);
            } else {
              return ProfileScreen();
            }
          }),
        ),
      ),
    );
  }
}
