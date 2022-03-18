import 'package:easy_peasy/components/auth/login_google_controller.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/screens/main/home_page.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoogleButton extends StatefulWidget {
  const GoogleButton({
    Key? key,
  }) : super(key: key);

  @override
  State<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
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
        onPressed: () async {
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //     NavigationBarCustom.routeName, (route) => false);
          final provider =
              Provider.of<LoginGoogleController>(context, listen: false);
          await provider.googleLogin(context);
        },
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
