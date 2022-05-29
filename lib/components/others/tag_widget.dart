import 'package:easy_peasy/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_peasy/size_config.dart';

class TagWidget extends StatelessWidget {
  const TagWidget({
    Key? key,
    required this.text,
    required this.side,
  }) : super(key: key);

  final String text;
  final String side;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: kWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: kMainTextColor,
            fontSize: getProportionateScreenWidth(16),
            fontWeight: FontWeight.w400,
          ),
          child: Row(
            children: [
              side == 'left'
                  ? Icon(
                      Icons.arrow_back_rounded,
                      color: kMainTextColor,
                      size: getProportionateScreenWidth(14),
                    )
                  : Text(text),
              const SizedBox(
                width: 5,
              ),
              side == 'left'
                  ? Text(text)
                  : side == 'delete'
                      ? Icon(
                          Icons.cancel_outlined,
                          color: kMainTextColor,
                          size: getProportionateScreenWidth(14),
                        )
                      : Icon(
                          Icons.arrow_forward_rounded,
                          color: kMainTextColor,
                          size: getProportionateScreenWidth(14),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
