import 'package:easy_peasy/screens/main/navigation_bar.dart';
import 'package:easy_peasy/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:easy_peasy/screens/auth/sign_in.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  OnboardingScreen.routeName: (context) => const OnboardingScreen(),
  SignIn.routeName: (context) => const SignIn(),
  NavigationBarCustom.routeName: (context) => const NavigationBarCustom(),
};
