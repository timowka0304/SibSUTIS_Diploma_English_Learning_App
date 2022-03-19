import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/screens/main/categories_page.dart';
import 'package:easy_peasy/screens/main/home_page.dart';
import 'package:easy_peasy/screens/main/profile_page.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NavigationBarCustom extends StatefulWidget {
  static String routeName = "/navigator";
  const NavigationBarCustom({Key? key}) : super(key: key);

  @override
  State<NavigationBarCustom> createState() => _NavigationBarCustomState();
}

class _NavigationBarCustomState extends State<NavigationBarCustom> {
  final items = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(Icons.book, size: getProportionateScreenWidth(25)),
        label: ""),
    BottomNavigationBarItem(
        icon: Icon(Icons.apps, size: getProportionateScreenWidth(25)),
        label: ""),
    BottomNavigationBarItem(
        icon: Icon(Icons.person, size: getProportionateScreenWidth(25)),
        label: ""),
  ];

  final screens = [
    const HomePageLogged(),
    const CategoriesPage(),
    const ProfilePage()
  ];

  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    SizeConfig().init(context);
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          selectedItemColor: kMainPink,
          unselectedItemColor: kMainPurple.withOpacity(0.5),
          elevation: 10,
          currentIndex: currentIndex,
          items: items,
          onTap: onTap,
        ),
        body: screens[currentIndex]);
  }
}
