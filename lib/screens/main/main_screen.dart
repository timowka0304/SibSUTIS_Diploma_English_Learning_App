import 'package:easy_peasy/components/main/bottom_tab_bar.dart';
import 'package:easy_peasy/screens/auth/sign_in.dart';
import 'package:easy_peasy/screens/main/categories_page.dart';
import 'package:easy_peasy/screens/main/home_page.dart';
import 'package:easy_peasy/screens/main/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MainScreenCheck extends StatelessWidget {
  const MainScreenCheck({Key? key}) : super(key: key);
  static String routeName = "/navigator";

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();

    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              return const MainScreen();
            } else {
              return const SignIn();
            }
          }
        });
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;

  final List<Widget> pageList = <Widget>[
    const HomePage(),
    const CategoriesPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pageList[pageIndex],
      bottomNavigationBar: BottomTabBar(
        index: pageIndex,
        onChangedTab: onChangeTab,
      ),
    );
  }

  void onChangeTab(int index) {
    setState(() {
      pageIndex = index;
    });
  }
}
