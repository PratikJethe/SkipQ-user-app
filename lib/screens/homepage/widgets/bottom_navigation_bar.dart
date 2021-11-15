import 'package:booktokenapp/providers/user_provider.dart';
import 'package:booktokenapp/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Consumer<UserProvider> bottomNavigationBar(context) {
  return Consumer<UserProvider>(builder: (context, userProvider, _) {
    return BottomNavigationBar(
      selectedLabelStyle: R.styles.fz16FontColorPrimaryD1,
      type: BottomNavigationBarType.fixed,
      landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
      unselectedItemColor: Colors.black,
      selectedItemColor: R.color.primaryD1,
      unselectedLabelStyle: TextStyle(color: Colors.black),
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
