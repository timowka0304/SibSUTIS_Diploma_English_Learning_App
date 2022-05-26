import 'dart:developer';

import 'package:easy_peasy/components/others/shared_pref.dart';
import 'package:easy_peasy/routes.dart';
import 'package:easy_peasy/screens/main/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'screens/onboarding/onboarding_screen.dart';

int? onBoardingScreenIsViewed;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await getOnboardInfo().then((gettedInfo) {
    onBoardingScreenIsViewed = gettedInfo;
  });

  await Firebase.initializeApp();
  try {
    await getDragHint().then((value) async {
      if (value) {
        await storeDragHint(true);
      } else {
        await storeDragHint(false);
      }
    });
  } catch (e) {
    await storeDragHint(true);
  }

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MaterialApp(
      title: "Easy Peasy",
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // inspect(onBoardingScreenIsViewed);

    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      builder: () => MaterialApp(
        title: "Easy Peasy",
        builder: (context, widget) {
          ScreenUtil.setContext(context);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        // ),
        initialRoute: onBoardingScreenIsViewed != null
            ? MainScreenCheck.routeName
            : OnboardingScreen.routeName,
        routes: routes,
      ),
    );
  }
}
