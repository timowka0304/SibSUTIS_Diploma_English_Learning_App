import 'package:easy_peasy/components/auth/auth_controller.dart';
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
            final user = FirebaseAuth.instance.currentUser!;
            uploadingData(user);
            return const MainScreen(
              pageIndex: 0,
              isStart: true,
            );
          } else {
            return const SignIn();
          }
        }
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
    required this.pageIndex,
    required this.isStart,
  }) : super(key: key);
  final int pageIndex;
  final bool isStart;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int page = 0;
  bool _done = false;

  final List<Widget> pageList = <Widget>[
    const HomePage(),
    const CategoriesPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    int newPage = widget.pageIndex;
    int pageIndexFinal = widget.isStart
        ? page
        : _done
            ? page
            : newPage;

    return Scaffold(
      extendBody: true,
      body: pageList[pageIndexFinal],
      bottomNavigationBar: BottomTabBar(
        index: pageIndexFinal,
        onChangedTab: onChangeTab,
      ),
    );
  }

  void onChangeTab(int index) {
    setState(
      () {
        page = index;
        _done = true;
      },
    );
  }
}
