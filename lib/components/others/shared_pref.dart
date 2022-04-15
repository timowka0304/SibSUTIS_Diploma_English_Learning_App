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

storeCategoriesInfo(
    String info,
    String beginers,
    String intermediate,
    String films,
    int beginersCount,
    int intermediateCount,
    int filmsCount) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('CategoriesPageImages', info);

  await prefs.setString('beginersDictionary', beginers);
  await prefs.setString('intermediateDictionary', intermediate);
  await prefs.setString('filmsDictionary', films);

  await prefs.setInt('beginersCount', beginersCount);
  await prefs.setInt('intermediateCount', intermediateCount);
  await prefs.setInt('filmsCount', filmsCount);

  await prefs.setInt('CategoriesPage', 1);
}

storeBeginNum(int num) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('CategoriesPage', 1);
}

Future getCategoriesInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('CategoriesPage');
}

Future getBeginersCount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('beginersCount');
}

Future getIntermediateCount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('intermediateCount');
}

Future getFilmsCount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('filmsCount');
}

Future getCategoriesImages() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('CategoriesPageImages');
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
