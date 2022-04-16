import 'package:easy_peasy/constants.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  int num;
  Icon icon;
  String title;
  String text;

  CategoryModel(
      {required this.num,
      required this.icon,
      required this.title,
      required this.text});
}
