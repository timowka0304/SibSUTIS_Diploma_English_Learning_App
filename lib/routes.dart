import 'package:easy_peasy/screens/main/main_screen.dart';
import 'package:easy_peasy/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  OnboardingScreen.routeName: (context) => const OnboardingScreen(),
  MainScreenCheck.routeName: (context) => const MainScreenCheck(),
};
