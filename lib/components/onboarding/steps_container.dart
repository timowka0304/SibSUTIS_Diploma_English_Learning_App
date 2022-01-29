import 'package:easy_peasy/size_config.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/models/onboarding_model.dart';
import 'package:flutter/material.dart';

class StepsContainer extends StatelessWidget {
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
                value: (page + 1) / (_list.length)),
          ),
          Center(
            child: InkWell(
              onTap: () {
                if (page < _list.length && page != _list.length - 1) {
                  _controller.animateToPage(page + 1,
                      duration: kAnimationDuration,
                      curve: Curves.easeInOutCirc);
                } else {
                  // TODO Navigate to Auth
                  // Navigator.of(context).pushAndRemoveUntil(
                  //   MaterialPageRoute(
                  //     builder: (_) =>
                  //         Login(screenHeight: SizeConfig.defaultSize * 30),
                  //   ),
                  //   (route) => false,
                  // );
                }
              },
              child: Container(
                width: getProportionateScreenHeight(50),
                height: getProportionateScreenHeight(50),
                decoration: BoxDecoration(
                    color: kMainPurple,
                    borderRadius: BorderRadius.all(
                        Radius.circular(getProportionateScreenHeight(100)))),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
