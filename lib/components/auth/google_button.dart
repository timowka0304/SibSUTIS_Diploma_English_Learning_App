import 'package:easy_peasy/components/auth/auth_controller.dart';
import 'package:easy_peasy/components/others/shared_pref_user.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/screens/main/main_screen.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GoogleButton extends StatefulWidget {
  GoogleButton({Key? key}) : super(key: key);

  State<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  @override
  Widget build(BuildContext context) {
    void _trySignIn() async {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      googleSignIn().then((value) async {
        if (value != false) {
          User? user = FirebaseAuth.instance.currentUser;
          await storeProfileUid(user!.uid);
          Navigator.pushReplacementNamed(context, MainScreenCheck.routeName);
          Navigator.of(context, rootNavigator: true).pop();
        }
        if (value == false) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      });
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(getProportionateScreenWidth(250),
              getProportionateScreenHeight(50)),
          maximumSize: Size(getProportionateScreenWidth(280),
              getProportionateScreenHeight(50)),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          primary: kWhite),
      onPressed: _trySignIn,
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
              color: kMainTextColor, fontSize: getProportionateScreenWidth(14)),
        ),
      ]),
    );
  }
}
