import 'dart:developer';
import 'dart:ui';

import 'package:easy_peasy/components/others/shared_pref.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/screens/learn/get_words_page.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:achievement_view/achievement_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/home";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool> checkMorningTime() async {
    if (DateTime.now().hour >= 4 && DateTime.now().hour <= 6) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkEveningTime() async {
    if (DateTime.now().hour >= 0 && DateTime.now().hour < 4) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> initial() async {
    await timeAchievement();
  }

  Future<void> timeAchievement() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();

    String user = FirebaseAuth.instance.currentUser!.uid.toString();
    print('user = ' + user);

    late bool _morningTime;
    late bool _eveningTime;

    late bool _morningTimeAchievement;
    late bool _eveningTimeAchievement;

    await getMorningAchievement(user).then((value) async {
      if (value != null) {
        print('not first');
        _morningTimeAchievement = value;
        inspect(_morningTimeAchievement);
        _morningTime = await checkMorningTime();
      } else {
        print('value = ' + value.toString());
        // _morningTimeAchievement = false;
        _morningTime = await checkMorningTime();
        if (_morningTime) {
          showAchievementView(context, 'morning1');
          _morningTimeAchievement = true;
          await storeMorningAchievement(_morningTimeAchievement, user);
        } else {
          _morningTimeAchievement = false;
          await storeMorningAchievement(_morningTimeAchievement, user);
        }
      }

      // inspect(_morningTimeAchievement);
    });

    await getEveningAchievement(user).then((data) async {
      if (data != null) {
        print('not first');
        _eveningTimeAchievement = data;
        inspect(_eveningTimeAchievement);
        _eveningTime = await checkEveningTime();
      } else {
        print('data = ' + data.toString());
        // _eveningTimeAchievement = false;
        _eveningTime = await checkEveningTime();
        // inspect(_eveningTime && !_eveningTimeAchievement);
        if (_eveningTime) {
          showAchievementView(context, 'evening1');
          _eveningTimeAchievement = true;
          await storeEveningAchievement(_eveningTimeAchievement, user);
        } else {
          _eveningTimeAchievement = false;
          await storeEveningAchievement(_eveningTimeAchievement, user);
        }
      }

      // inspect(_eveningTimeAchievement);
    });

    // _morningTimeAchievement ? null : _morningTime = await checkMorningTime();

    if (_morningTime && !_morningTimeAchievement) {
      showAchievementView(context, 'morning2');
      _morningTimeAchievement = true;
      await storeMorningAchievement(_morningTimeAchievement, user);
    }

    // _eveningTimeAchievement ? null : _eveningTime = await checkEveningTime();

    // inspect(_eveningTime && !_eveningTimeAchievement);
    if (_eveningTime && !_eveningTimeAchievement) {
      showAchievementView(context, 'evening2');
      _eveningTimeAchievement = true;
      await storeEveningAchievement(_eveningTimeAchievement, user);
    }

    print('_morningTime = ' + _morningTime.toString());
    print('_eveningTime = ' + _eveningTime.toString());
    print('_morningTimeAchievement = ' + _morningTimeAchievement.toString());
    print('_eveningTimeAchievement = ' + _eveningTimeAchievement.toString());
  }

  void showAchievementView(BuildContext context, String text) {
    AchievementView(
      context,
      title: text,
      subTitle: "Training completed successfully",
      //onTab: _onTabAchievement,
      //icon: Icon(Icons.insert_emoticon, color: Colors.white,),
      //typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
      //borderRadius: 5.0,
      color: kMainPurple,
      //textStyleTitle: TextStyle(),
      //textStyleSubTitle: TextStyle(),
      //alignment: Alignment.topCenter,
      //duration: Duration(seconds: 3),
      //isCircle: false,
      //     listener: (status) {
      //   print(status);
      //   //AchievementState.opening
      //   //AchievementState.open
      //   //AchievementState.closing
      //   //AchievementState.closed
      // }
    ).show();
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
