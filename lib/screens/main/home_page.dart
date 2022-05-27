import 'dart:developer';
import 'dart:ui';

import 'package:easy_peasy/components/others/achievements_controll.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/screens/learn/get_words_page.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/home";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> initial() async {
    // showAchievementView(context, AchivementsModel.list[0]);
    await firebaseRequest(context);
    // await timeAchievement(context);
  }

  @override
  void initState() {
    super.initState();
    initial();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: kSecondBlue,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            width: 300,
            child: Stack(
              children: [
                Card(
                  elevation: 10,
                  shadowColor: kMainTextColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  color: kWhite,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'english word',
                            style: TextStyle(
                                color: kMainTextColor,
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'transcription',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: kMainPurple,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.volume_up_rounded,
                                color: kMainPurple,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          Text(
            'Начнем учить слова?',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: kMainTextColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Жми на кнопку!',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: kMainTextColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 20,
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
            onPressed: () {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const GetWordsPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = 0.0;
                    const end = 1.0;
                    const curve = Curves.ease;

                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(
                      CurveTween(
                        curve: curve,
                      ),
                    );

                    return FadeTransition(
                      opacity: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.play_arrow_rounded,
                  color: kWhite,
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(10),
                ),
                Text(
                  "Начать",
                  style: TextStyle(
                      color: kWhite,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ],
      ))),
    );
  }
}
