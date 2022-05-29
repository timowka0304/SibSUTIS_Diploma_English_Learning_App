import 'package:easy_peasy/components/others/shared_pref.dart';
import 'package:easy_peasy/routes.dart';
import 'package:easy_peasy/screens/main/main_screen.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/onboarding/onboarding_screen.dart';

late bool onBoardingScreenIsViewed;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await getOnboardInfo().then(
      (value) {
        onBoardingScreenIsViewed = value;
      },
    );
  } catch (_) {
    onBoardingScreenIsViewed = false;
  }

  await Firebase.initializeApp();
  try {
    await getDragHint().then((value) async {
      value ? await storeDragHint(true) : await storeDragHint(false);
    });
  } catch (_) {
    await storeDragHint(true);
  }

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
    (_) {
      runApp(
        const MaterialApp(
          title: "Easy Peasy",
          debugShowCheckedModeBanner: false,
          home: MyApp(),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      title: "Easy Peasy",
      builder: (context, widget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: widget!,
        );
      },
      debugShowCheckedModeBanner: false,
      initialRoute: onBoardingScreenIsViewed
          ? MainScreenCheck.routeName
          : OnboardingScreen.routeName,
      routes: routes,
    );
  }
}
