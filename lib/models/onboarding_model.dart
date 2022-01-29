import 'package:easy_peasy/constants.dart';

class OnboardingModel {
  String image;
  String title;
  String text;

  OnboardingModel(
      {required this.image, required this.title, required this.text});
  static List<OnboardingModel> list = [
    OnboardingModel(
        image: k1stImageOnboardingPath,
        title: "Занимайся",
        text: "самостоятельно\nв интерактивных курсах"),
    OnboardingModel(
        image: k2ndImageOnboardingPath,
        title: "Слушай",
        text: "книги и подкасты\nна английском языке"),
    OnboardingModel(
        image: k3rdImageOnboardingPath,
        title: "Применяй",
        text: "полученные навыки\nв повседневной жизни")
  ];
}
