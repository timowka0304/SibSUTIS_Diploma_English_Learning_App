import 'package:easy_peasy/components/others/shared_pref.dart';
import 'package:easy_peasy/screens/auth/sign_in.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/models/onboarding_model.dart';
import 'package:flutter/material.dart';

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
              borderRadius: BorderRadius.circular(
                getProportionateScreenHeight(50),
              ),
              highlightColor: kMainPurple.withOpacity(0.4),
              splashColor: kMainPurple.withOpacity(0.5),
              onTap: () async {
                if (widget.page < widget._list.length &&
                    widget.page != widget._list.length - 1) {
                  widget._controller.animateToPage(widget.page + 1,
                      duration: kAnimationDuration,
                      curve: Curves.easeInOutCirc);
                } else {
                  await storeOnboardInfo();
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const SignIn(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = 0.0;
                        const end = 1.0;
                        const curve = Curves.ease;

                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(
                          CurveTween(
                            curve: curve,
                          ),
                        );

                        return FadeTransition(
                          opacity: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
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
