import 'package:easy_peasy/components/auth/auth_controller.dart';
import 'package:easy_peasy/components/others/shared_pref_user.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/screens/main/home_page.dart';
import 'package:easy_peasy/screens/main/navigation_bar.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      googleSignIn().then((value) {
        if (value != false) {
          User? user = FirebaseAuth.instance.currentUser;
          storeProfileUid(user!.uid);
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.pushReplacementNamed(
              context, NavigationBarCustom.routeName);
        }
        if (value == false) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      });
    }

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
                color: kMainTextColor,
                fontSize: getProportionateScreenWidth(14)),
          ),
        ]),
      ),
    );
  }
}
