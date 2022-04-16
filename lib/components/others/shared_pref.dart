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

storeCategoriesInfo(String wordsImage, String beginers, String intermediate,
    String films) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('categoriesPageImages', wordsImage);

  await prefs.setString('beginersDictionary', beginers);
  await prefs.setString('intermediateDictionary', intermediate);
  await prefs.setString('filmsDictionary', films);

  await prefs.setInt('categoriesPage', 1);
}

Future getCategoriesInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('categoriesPage');
}

Future getCategoriesImages() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('categoriesPageImages');
}

Future getBeginersDict() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('beginersDictionary');
}

Future getIntermediateDict() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('intermediateDictionary');
}

Future getFilmsDict() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('filmsDictionary');
}
