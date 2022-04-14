import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

storeProfileUid(String uid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('uid', uid);
}

Future<String> getProfileUid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('uid')!;
}

storeOnboardInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('onBoardingScreen', 1);
}

Future getOnboardInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('onBoardingScreen');
}

storeCategoriesInfo(String info) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('CategoriesPageImages', info);
  await prefs.setInt('CategoriesPage', 1);
  print("Stored");
}

Future getCategoriesInfo() async {
  final whenDone = Completer();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("Getted = ${prefs.getInt('CategoriesPage')}");
  return prefs.getInt('CategoriesPage');
}

Future getCategoriesImages() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('CategoriesPageImages');
}
