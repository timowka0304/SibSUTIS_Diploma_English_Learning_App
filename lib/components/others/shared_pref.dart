import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

storeOnboardInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('onBoardingScreen', true);
}

Future getOnboardInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onBoardingScreen');
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

Future storeDragHint(bool status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('dragHintStatus', status);
}

Future<bool> getDragHint() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('dragHintStatus')!;
}

Future storeMorningAchievement(bool status, String user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('morningAchievement ' + user, status);
}

Future getMorningAchievement(String user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('morningAchievement ' + user);
}

Future storeEveningAchievement(bool status, String user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('eveningAchievement ' + user, status);
}

Future getEveningAchievement(String user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('eveningAchievement ' + user);
}

Future storeNumWordsAchievement(bool status, String user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('learn100WordsAchievement ' + user, status);
}

Future getNumWordsAchievement(String user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('learn100WordsAchievement ' + user);
}
