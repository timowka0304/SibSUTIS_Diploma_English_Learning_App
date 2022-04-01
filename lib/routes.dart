import 'package:easy_peasy/screens/auth/sign_up.dart';
import 'package:easy_peasy/screens/main/home_page.dart';
import 'package:easy_peasy/screens/main/main_screen.dart';
import 'package:easy_peasy/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:easy_peasy/screens/auth/sign_in.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  OnboardingScreen.routeName: (context) => const OnboardingScreen(),
  SignIn.routeName: (context) => const SignIn(),
  MainScreenCheck.routeName: (context) => const MainScreenCheck(),
  HomePage.routeName: (context) => const HomePage(),
  SignUp.routeName: (context) => const SignUp(),
};
