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
  return prefs.getInt('onBoardingScreen')!;
}
