import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    // Firebase.initializeApp();
    return Scaffold(
        backgroundColor: kSecondBlue,
        body: SafeArea(
          child: Center(
            child: Column(children: [
              SizedBox(
                height: getProportionateScreenHeight(30),
              ),
              Expanded(
                child: Stack(children: [
                  Container(
                    margin: EdgeInsets.all(getProportionateScreenWidth(30)),
                    height: getProportionateScreenHeight(150),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(
                              getProportionateScreenWidth(0),
                              getProportionateScreenHeight(
                                  5)), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          SizedBox(
                            child: CircleAvatar(
                              radius: getProportionateScreenWidth(40),
                              backgroundColor: kWhite,
                              child: CircleAvatar(
                                radius: getProportionateScreenWidth(37),
                                backgroundImage: NetworkImage(user.photoURL!),
                              ),
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          Text(
                            user.displayName!,
                            style: TextStyle(
                                color: kMainTextColor,
                                fontSize: getProportionateScreenWidth(16),
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: getProportionateScreenHeight(10)),
                          Text(
                            user.email!,
                            style: TextStyle(
                                color: kMainTextColor,
                                fontSize: getProportionateScreenWidth(16),
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: getProportionateScreenHeight(20)),
                        ],
                      )),
                ]),
              ),
              Expanded(
                  child: Stack(children: [
                Container(
                  margin: EdgeInsets.all(getProportionateScreenWidth(30)),
                  height: getProportionateScreenHeight(230),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(
                            getProportionateScreenWidth(0),
                            getProportionateScreenHeight(
                                5)), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ])),
              ElevatedButton(
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
                      return kMainPink;
                    })),
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.exit_to_app,
                      color: kWhite,
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                    Text(
                      "Выйти",
                      style: TextStyle(
                          color: kWhite,
                          fontSize: getProportionateScreenWidth(16),
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(30),
              ),
            ]),
          ),
        ));
  }
}
