import 'package:easy_peasy/components/auth/auth_controller.dart';
import 'package:easy_peasy/components/others/dialogs.dart';
import 'package:easy_peasy/components/others/shared_pref_user.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/models/achivements_model.dart';
import 'package:easy_peasy/screens/auth/sign_in.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  late String uid;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    getProfileUid().then((gettedUid) {
      setState(() {
        uid = gettedUid;
      });
    });

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
                                        shape: const CircleBorder(),
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
                  Text(
                    "Достижения",
                    style: TextStyle(
                        color: kMainTextColor,
                        fontSize: getProportionateScreenWidth(16),
                        fontWeight: FontWeight.w600),
                  ),
                  Stack(children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(30),
                        getProportionateScreenHeight(0),
                        getProportionateScreenWidth(30),
                        getProportionateScreenHeight(30),
                      ),
                      height: getProportionateScreenHeight(150),
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
                              TextButton(
                                onPressed: () => showAchivementsDialog(
                                  context,
                                  AchivementsModel.list
                                      .firstWhere((e) => e.num == 1)
                                      .title,
                                  AchivementsModel.list
                                      .firstWhere((e) => e.num == 1)
                                      .text,
                                ),
                                style: ButtonStyle(
                                  textStyle: MaterialStateProperty.resolveWith<
                                      TextStyle>((Set<MaterialState> states) {
                                    return TextStyle(
                                      color: kMainTextColor,
                                      fontSize: getProportionateScreenWidth(14),
                                      fontWeight: FontWeight.w400,
                                    );
                                  }),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                    return kMainPink.withOpacity(0.1);
                                  }),
                                ),
                                child: Column(
                                  children: [
                                    AchivementsModel.list
                                        .firstWhere((e) => e.num == 1)
                                        .icon,
                                    SizedBox(
                                      height: getProportionateScreenHeight(15),
                                    ),
                                    Text(
                                      AchivementsModel.list
                                          .firstWhere((e) => e.num == 1)
                                          .title,
                                      style: TextStyle(
                                        color: kMainTextColor,
                                        fontSize:
                                            getProportionateScreenWidth(14),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () => showAchivementsDialog(
                                  context,
                                  AchivementsModel.list
                                      .firstWhere((e) => e.num == 2)
                                      .title,
                                  AchivementsModel.list
                                      .firstWhere((e) => e.num == 2)
                                      .text,
                                ),
                                style: ButtonStyle(
                                  textStyle: MaterialStateProperty.resolveWith<
                                      TextStyle>((Set<MaterialState> states) {
                                    return TextStyle(
                                      color: kMainTextColor,
                                      fontSize: getProportionateScreenWidth(14),
                                      fontWeight: FontWeight.w400,
                                    );
                                  }),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                    return kMainPink.withOpacity(0.1);
                                  }),
                                ),
                                child: Column(
                                  children: [
                                    AchivementsModel.list
                                        .firstWhere((e) => e.num == 2)
                                        .icon,
                                    SizedBox(
                                      height: getProportionateScreenHeight(15),
                                    ),
                                    Text(
                                      AchivementsModel.list
                                          .firstWhere((e) => e.num == 2)
                                          .title,
                                      style: TextStyle(
                                        color: kMainTextColor,
                                        fontSize:
                                            getProportionateScreenWidth(14),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () => showAchivementsDialog(
                                  context,
                                  AchivementsModel.list
                                      .firstWhere((e) => e.num == 3)
                                      .title,
                                  AchivementsModel.list
                                      .firstWhere((e) => e.num == 3)
                                      .text,
                                ),
                                style: ButtonStyle(
                                  textStyle: MaterialStateProperty.resolveWith<
                                      TextStyle>((Set<MaterialState> states) {
                                    return TextStyle(
                                      color: kMainTextColor,
                                      fontSize: getProportionateScreenWidth(14),
                                      fontWeight: FontWeight.w400,
                                    );
                                  }),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                    return kMainPink.withOpacity(0.1);
                                  }),
                                ),
                                child: Column(
                                  children: [
                                    AchivementsModel.list
                                        .firstWhere((e) => e.num == 3)
                                        .icon,
                                    SizedBox(
                                      height: getProportionateScreenHeight(15),
                                    ),
                                    Text(
                                      AchivementsModel.list
                                          .firstWhere((e) => e.num == 3)
                                          .title,
                                      style: TextStyle(
                                        color: kMainTextColor,
                                        fontSize:
                                            getProportionateScreenWidth(14),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
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
                            MaterialPageRoute(builder: (context) => const SignIn()));
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
