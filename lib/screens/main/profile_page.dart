import 'package:easy_peasy/components/auth/auth_controller.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/screens/auth/sign_in.dart';
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
              Stack(children: [
                Container(
                  margin: EdgeInsets.fromLTRB(
                      getProportionateScreenWidth(30),
                      getProportionateScreenHeight(30),
                      getProportionateScreenWidth(30),
                      getProportionateScreenHeight(0)),
                  height: getProportionateScreenHeight(200),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(getProportionateScreenWidth(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
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
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: getProportionateScreenWidth(12),
                                      child: MaterialButton(
                                        onPressed: () {},
                                        elevation: 0,
                                        focusElevation: 0,
                                        hoverElevation: 0,
                                        highlightElevation: 0,
                                        color: kMainPurple,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: kWhite,
                                          size: getProportionateScreenWidth(15),
                                        ),
                                        padding: EdgeInsets.all(
                                            getProportionateScreenWidth(2)),
                                        shape: CircleBorder(),
                                      )),
                                )),
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
                        Stack(
                          children: [
                            Container(
                              height: getProportionateScreenHeight(30),
                              width: getProportionateScreenWidth(150),
                              decoration: BoxDecoration(
                                color: kMainPink,
                                borderRadius: BorderRadius.circular(
                                    getProportionateScreenWidth(5)),
                              ),
                              child: Center(
                                  child: RichText(
                                      text: TextSpan(
                                          text: "Дней подряд: ",
                                          style: TextStyle(
                                            color: kWhite,
                                            fontWeight: FontWeight.w400,
                                            fontSize:
                                                getProportionateScreenWidth(14),
                                          ),
                                          children: [
                                    TextSpan(
                                      text: "2",
                                      style: TextStyle(
                                        color: kWhite,
                                        fontWeight: FontWeight.w800,
                                        fontSize:
                                            getProportionateScreenWidth(14),
                                      ),
                                    )
                                  ]))),
                            ),
                          ],
                        )
                      ],
                    )),
              ]),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(30),
                  ),
                  Stack(children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(30),
                        getProportionateScreenHeight(20),
                        getProportionateScreenWidth(30),
                        getProportionateScreenHeight(30),
                      ),
                      height: getProportionateScreenHeight(230),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              getProportionateScreenWidth(15)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(
                                getProportionateScreenWidth(0),
                                getProportionateScreenHeight(5),
                              ), // changes position of shadow
                            ),
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.light_mode,
                                    color: kMainPurple.withOpacity(0.3),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(10),
                                  ),
                                  Text("Title"),
                                  Text("Decription"),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(
                                    Icons.dark_mode,
                                    color: kMainPurple.withOpacity(1),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(10),
                                  ),
                                  Text("Title"),
                                  Text("Decription"),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(
                                    Icons.watch_later,
                                    color: kMainPurple.withOpacity(0.3),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(10),
                                  ),
                                  Text("Title"),
                                  Text("Decription"),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.turned_in,
                                    color: kMainPurple.withOpacity(0.3),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(10),
                                  ),
                                  Text("Title"),
                                  Text("Decription"),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(
                                    Icons.grade,
                                    color: kMainPurple.withOpacity(0.3),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(10),
                                  ),
                                  Text("Title"),
                                  Text("Decription"),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Text(
                          "Настройка уведомлений",
                          style: TextStyle(
                            color: kMainTextColor.withOpacity(0.8),
                            fontSize: getProportionateScreenWidth(14),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          "Часто задаваемые вопросы",
                          style: TextStyle(
                            color: kMainTextColor.withOpacity(0.8),
                            fontSize: getProportionateScreenWidth(14),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          "Политика конфиденциальности",
                          style: TextStyle(
                            color: kMainTextColor.withOpacity(0.8),
                            fontSize: getProportionateScreenWidth(14),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          return kMainPink;
                        })),
                    onPressed: () => signOutUser().then(
                      (value) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => SignIn()));
                      },
                    ),
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
                    height: getProportionateScreenHeight(20),
                  ),
                ],
              ))
            ]),
          ),
        ));
  }
}
