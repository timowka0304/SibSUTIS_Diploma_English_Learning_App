import 'package:easy_peasy/routes.dart';
import 'package:easy_peasy/screens/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/onboarding/onboarding_screen.dart';

int? onBoardingScreenIsViewed;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  onBoardingScreenIsViewed = prefs.getInt('onBoardingScreen');

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      ),
      initialRoute: onBoardingScreenIsViewed != null
          ? SignIn.routeName
          : OnboardingScreen.routeName,
      routes: routes,
    );
  }
}
