import 'package:easy_peasy/constants.dart';
import 'package:flutter/material.dart';

class AchivementsModel {
  bool status;
  int num;
  Icon icon;
  String title;
  String text;

  AchivementsModel({
    required this.num,
    required this.status,
    required this.icon,
    required this.title,
    required this.text,
  });
  static List<AchivementsModel> list = [
    AchivementsModel(
        num: 1,
        status: false,
        icon: const Icon(
          Icons.light_mode,
        ),
        title: "Не рано",
        text: "Воспользуйся приложением в период с 4 до 6 часов утра"),
    AchivementsModel(
        num: 2,
        status: false,
        icon: const Icon(
          Icons.school_rounded,
        ),
        title: "Полиглот",
        text: "Выучи 100 слов"),
    AchivementsModel(
        num: 3,
        status: false,
        icon: const Icon(
          Icons.dark_mode,
        ),
        title: "Не поздно",
        text: "Воспользуйся приложением в период с 0 до 4 часов ночи"),
  ];
}
