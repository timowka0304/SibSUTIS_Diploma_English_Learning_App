import 'package:easy_peasy/size_config.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/models/onboarding_model.dart';
import 'package:flutter/material.dart';

class MainContent extends StatelessWidget {
  const MainContent(
      {Key? key, required List<OnboardingModel> list, required this.index})
      : _list = list,
        super(key: key);

  final List<OnboardingModel> _list;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.defaultSize,
        ),
        Expanded(
          flex: 3,
          child: Image.asset(
            _list[index].image,
            height: getProportionateScreenHeight(330),
            width: getProportionateScreenWidth(350),
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(80),
        ),
        Text(_list[index].title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: kMainTextColor,
                fontWeight: FontWeight.w600,
                fontSize: getProportionateScreenWidth(20))),
        Text(_list[index].text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: kMainTextColor,
                fontWeight: FontWeight.w300,
                fontSize: getProportionateScreenWidth(20))),
      ],
    );
  }
}
