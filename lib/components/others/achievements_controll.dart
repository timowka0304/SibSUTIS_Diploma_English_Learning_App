import 'package:achievement_view/achievement_view.dart';
import 'package:achievement_view/achievement_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_peasy/components/others/shared_pref.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/models/achivements_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> checkNumOfLearnedWords(BuildContext context) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then(
    (value) async {
      if (value.get('numberOfLearnedWords') == 1) {
        await getNumWordsAchievement(FirebaseAuth.instance.currentUser!.uid)
            .then(
          (value) async {
            if (value == null) {
              showAchievementView(context, AchivementsModel.list[1]);
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update(
                {
                  'learn100WordsAchievement': true,
                },
              );
              await storeNumWordsAchievement(
                  true, FirebaseAuth.instance.currentUser!.uid);
            }
          },
        );
      }
    },
  );
}

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

Future<void> firebaseRequest(BuildContext context) async {
  FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) async {
    try {
      bool _morningTimeAchievement = value.get('morningTimeAchievement');
      bool _eveningTimeAchievement = value.get('eveningTimeAchievement');
      await storeMorningAchievement(
          _morningTimeAchievement, FirebaseAuth.instance.currentUser!.uid);
      await storeEveningAchievement(
          _eveningTimeAchievement, FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      // print(e);
      await timeAchievement(context);
    }
  });
}

Future<void> timeAchievement(BuildContext context) async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear();

  String user = FirebaseAuth.instance.currentUser!.uid.toString();

  late bool _morningTime;
  late bool _eveningTime;

  late bool _morningTimeAchievement;
  late bool _eveningTimeAchievement;

  await getMorningAchievement(user).then((value) async {
    if (value != null) {
      _morningTimeAchievement = value;
      _morningTime = await checkMorningTime();
    } else {
      _morningTime = await checkMorningTime();
      if (_morningTime) {
        showAchievementView(context, AchivementsModel.list[0]);
        _morningTimeAchievement = true;
        await storeMorningAchievement(_morningTimeAchievement, user);
      } else {
        _morningTimeAchievement = false;
        await storeMorningAchievement(_morningTimeAchievement, user);
      }
    }
  });

  await getEveningAchievement(user).then((data) async {
    if (data != null) {
      _eveningTimeAchievement = data;
      _eveningTime = await checkEveningTime();
    } else {
      _eveningTime = await checkEveningTime();
      if (_eveningTime) {
        showAchievementView(context, AchivementsModel.list[2]);
        _eveningTimeAchievement = true;
        await storeEveningAchievement(_eveningTimeAchievement, user);
      } else {
        _eveningTimeAchievement = false;
        await storeEveningAchievement(_eveningTimeAchievement, user);
      }
    }
  });

  if (_morningTime && !_morningTimeAchievement) {
    showAchievementView(context, AchivementsModel.list[0]);
    _morningTimeAchievement = true;
    await storeMorningAchievement(_morningTimeAchievement, user);
  }
  if (_eveningTime && !_eveningTimeAchievement) {
    showAchievementView(context, AchivementsModel.list[2]);
    _eveningTimeAchievement = true;
    await storeEveningAchievement(_eveningTimeAchievement, user);
  }

  if (_morningTimeAchievement) {
    FirebaseFirestore.instance.collection('users').doc(user).update(
      {
        'morningTimeAchievement': true,
      },
    );
  }

  if (_eveningTimeAchievement) {
    FirebaseFirestore.instance.collection('users').doc(user).update(
      {
        'eveningTimeAchievement': true,
      },
    );
  }

  // print('_morningTime = ' + _morningTime.toString());
  // print('_eveningTime = ' + _eveningTime.toString());
  // print('_morningTimeAchievement = ' + _morningTimeAchievement.toString());
  // print('_eveningTimeAchievement = ' + _eveningTimeAchievement.toString());
}

void showAchievementView(BuildContext context, AchivementsModel achivement) {
  AchievementView(
    context,
    title: achivement.title,
    subTitle: achivement.text,
    icon: Icon(
      achivement.icon.icon,
      color: kMainPink,
    ),
    iconBackgroundColor: kWhite,
    typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
    iconBorderRadius: const BorderRadius.only(
      topLeft: Radius.circular(10.0),
      bottomLeft: Radius.circular(10.0),
    ),
    color: kMainPurple,
    //textStyleTitle: TextStyle(),
    //textStyleSubTitle: TextStyle(),
    //alignment: Alignment.topCenter,
    duration: const Duration(
      seconds: 3,
    ),
  ).show();
}
