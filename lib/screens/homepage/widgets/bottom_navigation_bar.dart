import 'package:skipq/providers/user_provider.dart';
import 'package:skipq/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Consumer<UserProvider> bottomNavigationBar(context) {
  return Consumer<UserProvider>(builder: (context, userProvider, _) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
      unselectedItemColor: Colors.black,
      selectedItemColor: R.color.primaryD1,
      selectedLabelStyle: R.styles.fz14FontColorPrimary.merge(R.styles.fw700),
      unselectedLabelStyle: R.styles.fz14Fw700,
      currentIndex: userProvider.bottomNavIndex,
      onTap: (index) {
        print(index);
        userProvider.setBottomNavIndex = index;
      },
      items: [
        bottomNavigatorItem(Icons.home, 'Home'),
        bottomNavigatorItem(Icons.search, 'Search'),
        bottomNavigatorItem(Icons.bookmark, 'My tokens'),
        bottomNavigatorItem(Icons.account_circle_rounded, 'Profile'),
      ],
    );
  });
}

bottomNavigatorItem(IconData icon, String text) {
  return BottomNavigationBarItem(icon: Icon(icon), label: text);
}
