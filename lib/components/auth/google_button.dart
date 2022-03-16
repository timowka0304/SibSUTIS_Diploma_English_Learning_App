import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(50),
      width: getProportionateScreenWidth(230),
      child: ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              return kWhite;
            })),
        onPressed: () {},
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image(
            image: const AssetImage(
              kLogoGoogle,
            ),
            width: getProportionateScreenWidth(25),
          ),
          SizedBox(
            width: getProportionateScreenWidth(20),
          ),
          Text(
            "Войти через Google",
            style: TextStyle(
                color: kMainTextColor,
                fontSize: getProportionateScreenWidth(14)),
          ),
        ]),
      ),
    );
  }
}
