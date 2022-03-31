import 'package:easy_peasy/components/others/shared_pref_user.dart';
import 'package:easy_peasy/screens/auth/sign_in.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/models/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepsContainer extends StatefulWidget {
  const StepsContainer({
    Key? key,
    required this.page,
    required List<OnboardingModel> list,
    required PageController controller,
  })  : _list = list,
        _controller = controller,
        super(key: key);

  final int page;
  final List<OnboardingModel> _list;
  final PageController _controller;

  @override
  State<StepsContainer> createState() => _StepsContainerState();
}

class _StepsContainerState extends State<StepsContainer> {
  _storeOnboardInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoardingScreen', 1);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenHeight(60),
      height: getProportionateScreenHeight(60),
      child: Stack(
        children: [
          SizedBox(
            width: getProportionateScreenHeight(60),
            height: getProportionateScreenHeight(60),
            child: CircularProgressIndicator(
                strokeWidth: getProportionateScreenHeight(4),
                valueColor: const AlwaysStoppedAnimation(kMainPink),
                value: (widget.page + 1) / (widget._list.length)),
          ),
          Center(
            child: InkWell(
              onTap: () async {
                if (widget.page < widget._list.length &&
                    widget.page != widget._list.length - 1) {
                  widget._controller.animateToPage(widget.page + 1,
                      duration: kAnimationDuration,
                      curve: Curves.easeInOutCirc);
                } else {
                  await storeOnboardInfo();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      SignIn.routeName, (route) => false);
                }
              },
              child: Container(
                width: getProportionateScreenHeight(50),
                height: getProportionateScreenHeight(50),
                decoration: BoxDecoration(
                    color: kMainPurple,
                    borderRadius: BorderRadius.all(
                        Radius.circular(getProportionateScreenHeight(100)))),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: getProportionateScreenHeight(23),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
