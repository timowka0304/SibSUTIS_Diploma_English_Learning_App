import 'package:easy_peasy/components/onboarding/main_content.dart';
import 'package:easy_peasy/components/onboarding/skip_button.dart';
import 'package:easy_peasy/components/onboarding/steps_container.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/models/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<OnboardingModel> _list = OnboardingModel.list;
  int page = 0;
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _controller.addListener(() {
      setState(() {
        page = _controller.page!.round();
      });
    });
    return Scaffold(
        backgroundColor: kWhite,
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
              flex: 1,
              child: page == 2
                  ? Container(color: Colors.white)
                  : SkipButton(controller: _controller),
            ),
            Expanded(
                flex: 4,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _list.length,
                  itemBuilder: (context, index) => MainContent(
                    list: _list,
                    index: index,
                  ),
                  physics: const BouncingScrollPhysics(),
                )),
            Padding(
              padding: EdgeInsets.only(
                  bottom: getProportionateScreenHeight(100),
                  top: getProportionateScreenHeight(100)),
              child: StepsContainer(
                  page: page, list: _list, controller: _controller),
            ),
          ],
        )));
  }
}
