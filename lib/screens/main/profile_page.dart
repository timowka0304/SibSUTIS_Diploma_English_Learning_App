import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_peasy/components/auth/auth_controller.dart';
import 'package:easy_peasy/components/others/dialogs.dart';
import 'package:easy_peasy/components/others/firebase_storage.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/models/achivements_model.dart';
import 'package:easy_peasy/screens/auth/sign_in.dart';
import 'package:easy_peasy/screens/help/help_page.dart';
import 'package:easy_peasy/screens/rating/rating_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_peasy/size_config.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<DocumentSnapshot> _dataFuture;
  late User _user;
  late String _userImg = _user.photoURL!;
  late String uid;

  @override
  void initState() {
    firebaseRequest();
    getAchievementsInfo();
    super.initState();
  }

  Future<void> firebaseRequest() async {
    _user = FirebaseAuth.instance.currentUser!;
    _dataFuture =
        FirebaseFirestore.instance.collection('users').doc(_user.uid).get();
  }

  Future<void> getAchievementsInfo() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (value) async {
        try {
          AchivementsModel.list[0].status =
              await value.get('morningTimeAchievement');
        } catch (_) {
          AchivementsModel.list[0].status = false;
        }
        try {
          AchivementsModel.list[1].status =
              await value.get('learn100WordsAchievement');
        } catch (_) {
          AchivementsModel.list[1].status = false;
        }
        try {
          AchivementsModel.list[2].status =
              await value.get('eveningTimeAchievement');
        } catch (_) {
          AchivementsModel.list[2].status = false;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _dataFuture,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: kSecondBlue,
            body: SafeArea(
              child: Center(
                child: Text(
                  "Ошибка",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kMainTextColor,
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: kSecondBlue,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: getProportionateScreenHeight(30),
                    ),
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                            getProportionateScreenWidth(30),
                            getProportionateScreenHeight(30),
                            getProportionateScreenWidth(30),
                            getProportionateScreenHeight(0),
                          ),
                          height: getProportionateScreenHeight(220),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              getProportionateScreenWidth(15),
                            ),
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
                                    backgroundImage:
                                        CachedNetworkImageProvider(_userImg),
                                    backgroundColor: kMainPink,
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: getProportionateScreenWidth(12),
                                        child: MaterialButton(
                                          onPressed: () =>
                                              updateImg(_user).then(
                                            (downloadUrl) {
                                              _user.updatePhotoURL(downloadUrl);

                                              setState(() {
                                                _user.updatePhotoURL(
                                                    downloadUrl);
                                                _userImg = downloadUrl;
                                              });
                                            },
                                          ),
                                          elevation: 0,
                                          focusElevation: 0,
                                          hoverElevation: 0,
                                          highlightElevation: 0,
                                          color: kMainPurple,
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: kWhite,
                                            size:
                                                getProportionateScreenWidth(14),
                                          ),
                                          padding: EdgeInsets.all(
                                            getProportionateScreenWidth(5),
                                          ),
                                          shape: const CircleBorder(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(20),
                              ),
                              Text(
                                (snapshot.data!.data()
                                    as Map<String, dynamic>)['username'],
                                style: TextStyle(
                                  color: kMainTextColor,
                                  fontSize: getProportionateScreenWidth(18),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              Text(
                                (snapshot.data!.data()
                                    as Map<String, dynamic>)['email'],
                                style: TextStyle(
                                  color: kMainTextColor,
                                  fontSize: getProportionateScreenWidth(18),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(20),
                              ),
                              Stack(
                                children: [
                                  Container(
                                    height: getProportionateScreenHeight(30),
                                    width: getProportionateScreenWidth(150),
                                    decoration: BoxDecoration(
                                      color: kMainPink,
                                      borderRadius: BorderRadius.circular(
                                        getProportionateScreenWidth(5),
                                      ),
                                    ),
                                    child: Center(
                                      child: RichText(
                                        text: TextSpan(
                                          text: "Слов выучено: ",
                                          style: TextStyle(
                                            color: kWhite,
                                            fontWeight: FontWeight.w400,
                                            fontSize:
                                                getProportionateScreenWidth(16),
                                          ),
                                          children: [
                                            TextSpan(
                                              text: (snapshot.data!.data()
                                                          as Map<String,
                                                              dynamic>)[
                                                      'numberOfLearnedWords']
                                                  .toString(),
                                              style: TextStyle(
                                                color: kWhite,
                                                fontWeight: FontWeight.w800,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: getProportionateScreenHeight(50),
                        ),
                        Text(
                          "Достижения",
                          style: TextStyle(
                            color: kMainTextColor,
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(20),
                        ),
                        Stack(
                          children: [
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
                                  getProportionateScreenWidth(15),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.05),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                      getProportionateScreenWidth(0),
                                      getProportionateScreenHeight(5),
                                    ),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        16),
                                                fontWeight: FontWeight.w400,
                                              );
                                            },
                                          ),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              return kMainPink.withOpacity(0.1);
                                            },
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(
                                              AchivementsModel.list
                                                  .firstWhere((e) => e.num == 1)
                                                  .icon
                                                  .icon,
                                              color: AchivementsModel.list
                                                      .firstWhere(
                                                          (e) => e.num == 1)
                                                      .status
                                                  ? kMainPurple
                                                  : kMainPurple
                                                      .withOpacity(0.3),
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      16),
                                            ),
                                            Text(
                                              AchivementsModel.list
                                                  .firstWhere((e) => e.num == 1)
                                                  .title,
                                              style: TextStyle(
                                                color: kMainTextColor,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        16),
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
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        16),
                                                fontWeight: FontWeight.w400,
                                              );
                                            },
                                          ),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              return kMainPink.withOpacity(0.1);
                                            },
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(
                                              AchivementsModel.list
                                                  .firstWhere((e) => e.num == 2)
                                                  .icon
                                                  .icon,
                                              color: AchivementsModel.list
                                                      .firstWhere(
                                                          (e) => e.num == 2)
                                                      .status
                                                  ? kMainPurple
                                                  : kMainPurple
                                                      .withOpacity(0.3),
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      16),
                                            ),
                                            Text(
                                              AchivementsModel.list
                                                  .firstWhere((e) => e.num == 2)
                                                  .title,
                                              style: TextStyle(
                                                color: kMainTextColor,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        16),
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
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        16),
                                                fontWeight: FontWeight.w400,
                                              );
                                            },
                                          ),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              return kMainPink.withOpacity(0.1);
                                            },
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(
                                              AchivementsModel.list
                                                  .firstWhere((e) => e.num == 3)
                                                  .icon
                                                  .icon,
                                              color: AchivementsModel.list
                                                      .firstWhere(
                                                          (e) => e.num == 3)
                                                      .status
                                                  ? kMainPurple
                                                  : kMainPurple
                                                      .withOpacity(0.3),
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      16),
                                            ),
                                            Text(
                                              AchivementsModel.list
                                                  .firstWhere((e) => e.num == 3)
                                                  .title,
                                              style: TextStyle(
                                                color: kMainTextColor,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        16),
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
                        Padding(
                          padding: EdgeInsets.all(
                            getProportionateScreenHeight(20),
                          ),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const RatingPage(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
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
                                child: Text(
                                  "Рейтинг пользователей",
                                  style: TextStyle(
                                    color: kMainTextColor.withOpacity(0.8),
                                    fontSize: getProportionateScreenWidth(16),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(20),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const HelpPage(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
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
                                child: Text(
                                  "Помощь по приложению",
                                  style: TextStyle(
                                    color: kMainTextColor.withOpacity(0.8),
                                    fontSize: getProportionateScreenWidth(16),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(30),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                    getProportionateScreenWidth(110),
                                    getProportionateScreenHeight(50),
                                  ),
                                  maximumSize: Size(
                                    getProportionateScreenWidth(160),
                                    getProportionateScreenHeight(50),
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  primary: kMainPink,
                                ),
                                onPressed: () => signOutUser().then(
                                  (_) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => const SignIn(),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
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
                                      width: getProportionateScreenWidth(10),
                                    ),
                                    Text(
                                      "Выйти",
                                      style: TextStyle(
                                        color: kWhite,
                                        fontSize:
                                            getProportionateScreenWidth(16),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
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
            ),
          );
        }

        return const Scaffold(
          backgroundColor: kSecondBlue,
          body: SafeArea(
            child: Center(
              child: CircularProgressIndicator(
                color: kMainPink,
              ),
            ),
          ),
        );
      },
    );
  }
}
