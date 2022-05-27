import 'package:easy_peasy/size_config.dart';
import 'package:easy_peasy/constants.dart';
import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({Key? key, required PageController controller})
      : _controller = controller,
        super(key: key);

  final PageController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
              highlightColor: kMainPurple.withOpacity(0.1),
              splashColor: kMainPurple.withOpacity(0.1),
              onTap: () {
                _controller.animateToPage(2,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOutCirc);
              },
              child: Text(
                'Пропустить',
                style: TextStyle(
                    color: kMainPurple,
                    fontWeight: FontWeight.w600,
                    fontSize: getProportionateScreenWidth(14)),
              )),
        ],
      ),
    );
  }
}
