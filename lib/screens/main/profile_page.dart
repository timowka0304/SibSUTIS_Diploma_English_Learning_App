import 'package:easy_peasy/components/auth/auth_controller.dart';
import 'package:easy_peasy/components/others/dialogs.dart';
import 'package:easy_peasy/components/others/shared_pref.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/models/achivements_model.dart';
import 'package:easy_peasy/screens/auth/sign_in.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      uid = gettedUid;
    });

    return Scaffold(
      backgroundColor: kSecondBlue,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: ScreenUtil().setHeight(30),
              ),
              Stack(children: [
                Container(
                  margin: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(30),
                    ScreenUtil().setHeight(30),
                    ScreenUtil().setWidth(30),
                    ScreenUtil().setHeight(0),
                  ),
                  height: ScreenUtil().setHeight(220),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(
                          ScreenUtil().setWidth(0),
                          ScreenUtil().setHeight(5),
                        ), // changes position of shadow
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
                            radius: ScreenUtil().setWidth(40),
                            backgroundColor: kWhite,
                            child: CircleAvatar(
                                radius: ScreenUtil().setWidth(37),
                                backgroundImage: NetworkImage(user.photoURL!),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: ScreenUtil().setWidth(12),
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
                                          size: ScreenUtil().setWidth(15),
                                        ),
                                        padding: EdgeInsets.all(
                                          ScreenUtil().setWidth(5),
                                        ),
                                        shape: const CircleBorder(),
                                      )),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        Text(
                          user.displayName!,
                          style: TextStyle(
                            color: kMainTextColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(10),
                        ),
                        Text(
                          user.email!,
                          style: TextStyle(
                            color: kMainTextColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        Stack(
                          children: [
                            Container(
                              height: ScreenUtil().setHeight(30),
                              width: ScreenUtil().setWidth(150),
                              decoration: BoxDecoration(
                                color: kMainPink,
                                borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(5),
                                ),
                              ),
                              child: Center(
                                  child: RichText(
                                      text: TextSpan(
                                          text: "Дней подряд: ",
                                          style: TextStyle(
                                            color: kWhite,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.sp,
                                          ),
                                          children: [
                                    TextSpan(
                                      text: "2",
                                      style: TextStyle(
                                        color: kWhite,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16.sp,
                                      ),
                                    )
                                  ]))),
                            ),
                          ],
                        )
                      ],
                    )),
              ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: ScreenUtil().setHeight(30),
                  ),
                  Text(
                    "Достижения",
                    style: TextStyle(
                        color: kMainTextColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(30),
                          ScreenUtil().setHeight(0),
                          ScreenUtil().setWidth(30),
                          ScreenUtil().setHeight(30),
                        ),
                        height: ScreenUtil().setHeight(150),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.05),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(
                                  ScreenUtil().setWidth(0),
                                  ScreenUtil().setHeight(5),
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
                                    textStyle: MaterialStateProperty
                                        .resolveWith<TextStyle>(
                                            (Set<MaterialState> states) {
                                      return TextStyle(
                                        color: kMainTextColor,
                                        fontSize: 16.sp,
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
                                        MaterialStateProperty.resolveWith<
                                            Color>((Set<MaterialState> states) {
                                      return kMainPink.withOpacity(0.1);
                                    }),
                                  ),
                                  child: Column(
                                    children: [
                                      AchivementsModel.list
                                          .firstWhere((e) => e.num == 1)
                                          .icon,
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(15),
                                      ),
                                      Text(
                                        AchivementsModel.list
                                            .firstWhere((e) => e.num == 1)
                                            .title,
                                        style: TextStyle(
                                          color: kMainTextColor,
                                          fontSize: 16.sp,
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
                                    textStyle: MaterialStateProperty
                                        .resolveWith<TextStyle>(
                                            (Set<MaterialState> states) {
                                      return TextStyle(
                                        color: kMainTextColor,
                                        fontSize: 18.sp,
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
                                        MaterialStateProperty.resolveWith<
                                            Color>((Set<MaterialState> states) {
                                      return kMainPink.withOpacity(0.1);
                                    }),
                                  ),
                                  child: Column(
                                    children: [
                                      AchivementsModel.list
                                          .firstWhere((e) => e.num == 2)
                                          .icon,
                                      SizedBox(
                                        height: ScreenUtil().setHeight(15),
                                      ),
                                      Text(
                                        AchivementsModel.list
                                            .firstWhere((e) => e.num == 2)
                                            .title,
                                        style: TextStyle(
                                          color: kMainTextColor,
                                          fontSize: 16.sp,
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
                                    textStyle: MaterialStateProperty
                                        .resolveWith<TextStyle>(
                                            (Set<MaterialState> states) {
                                      return TextStyle(
                                        color: kMainTextColor,
                                        fontSize: 16.sp,
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
                                        MaterialStateProperty.resolveWith<
                                            Color>((Set<MaterialState> states) {
                                      return kMainPink.withOpacity(0.1);
                                    }),
                                  ),
                                  child: Column(
                                    children: [
                                      AchivementsModel.list
                                          .firstWhere((e) => e.num == 3)
                                          .icon,
                                      SizedBox(
                                        height: ScreenUtil().setHeight(15),
                                      ),
                                      Text(
                                        AchivementsModel.list
                                            .firstWhere((e) => e.num == 3)
                                            .title,
                                        style: TextStyle(
                                          color: kMainTextColor,
                                          fontSize: 16.sp,
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
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Text(
                          "Настройка уведомлений",
                          style: TextStyle(
                            color: kMainTextColor.withOpacity(0.8),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          "Часто задаваемые вопросы",
                          style: TextStyle(
                            color: kMainTextColor.withOpacity(0.8),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          "Политика конфиденциальности",
                          style: TextStyle(
                            color: kMainTextColor.withOpacity(0.8),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(30),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        ScreenUtil().setWidth(135),
                        ScreenUtil().setHeight(50),
                      ),
                      maximumSize: Size(
                        ScreenUtil().setWidth(185),
                        ScreenUtil().setHeight(50),
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      primary: kMainPink,
                    ),
                    onPressed: () => signOutUser().then(
                      (value) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const SignIn()));
                      },
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.exit_to_app,
                          color: kWhite,
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Text(
                          "Выйти",
                          style: TextStyle(
                              color: kWhite,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
