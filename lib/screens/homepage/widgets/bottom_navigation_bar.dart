import 'package:booktokenapp/resources/resources.dart';
import 'package:flutter/material.dart';

BottomNavigationBar bottomNavigationBar(index, onTap) {
  return BottomNavigationBar(
    selectedLabelStyle: R.styles.fz16FontColorPrimaryD1,
    type: BottomNavigationBarType.fixed,
    landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
    unselectedItemColor: Colors.black,
    selectedItemColor: R.color.primaryD1,
    unselectedLabelStyle: TextStyle(color: Colors.black),
    currentIndex: index,
    onTap: onTap,
    items: [
      bottomNavigatorItem(Icons.home, 'Home'),
      bottomNavigatorItem(Icons.search, 'Search'),
      bottomNavigatorItem(Icons.bookmark, 'My tokens'),
      bottomNavigatorItem(Icons.account_circle_rounded, 'Profile'),
    ],
  );
}

bottomNavigatorItem(IconData icon, String text) {
  return BottomNavigationBarItem(icon: Icon(icon), label: text);
}
