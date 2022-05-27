import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_peasy/components/others/firebase_storage.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/screens/learn/learn_page.dart';
import 'package:easy_peasy/screens/main/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GetWordsPage extends StatefulWidget {
  const GetWordsPage({Key? key}) : super(key: key);

  @override
  State<GetWordsPage> createState() => _GetWordsPageState();
}

class _GetWordsPageState extends State<GetWordsPage> {
  late List<String> wordsList;
  late Map<String, dynamic> data;
  late Map<String, dynamic> fullDataWords;
  late Future<DocumentSnapshot> _dataStream;
  late User _user;

  @override
  void initState() {
    firebaseRequest();
    super.initState();
  }

  Future<void> firebaseRequest() async {
    _user = FirebaseAuth.instance.currentUser!;

    _dataStream = FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .collection('dictionary')
        .doc('dictionary')
        .get();
    // _dataStream.then((value) => print(value.data()));
  }

  Future<void> setWordsInList(Map<String, dynamic> snapshot) async {
    wordsList = [];
    fullDataWords = {};

    for (var element in snapshot.entries) {
      wordsList.add(element.key);
    }
    wordsList.shuffle();

    for (var element in wordsList) {
      fullDataWords.addAll({element: snapshot[element]});
    }
    inspect(fullDataWords);
  }

  Future<void> goToNewPage(
    Map<String, dynamic> snapshot,
    BuildContext context,
  ) async {
    await setWordsInList(snapshot);
    Navigator.pop(context);
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LearnPage(
          wordsList: List<String>.from(wordsList),
          fullDataWords: fullDataWords,
          user: _user,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _dataStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            backgroundColor: kSecondBlue,
            body: SafeArea(
              child: Center(
                child: Text(
                  "Ошибка",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kMainTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }

        try {
          // if (snapshot.data!.data() == null) {
          //   print('go');
          //   setState(() {
          //   });
          // }
          if ((snapshot.data!.data() as Map<String, dynamic>).isEmpty) {
            return Scaffold(
              backgroundColor: kSecondBlue,
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'В твоем словаре пусто!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kMainTextColor,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Добавляй новые слова для изучения\nво вкладке «Категории»\n',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kMainTextColor,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w400,
                        ),
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
                          primary: kMainPurple,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const MainScreen(
                                pageIndex: 1,
                                isStart: false,
                              ),
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
                          'Перейти',
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
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
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const MainScreen(
                                pageIndex: 0,
                                isStart: false,
                              ),
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
                          'На главную',
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        } catch (e) {
          print(e.hashCode);
        }

        // if (snapshot.hasData && snapshot.data!.exists) {
        //   return Text("Document does not exist");
        // }

        if (snapshot.connectionState == ConnectionState.done) {
          // inspect(!snapshot.data!.exists);
          // inspect(snapshot.hasData);
          // inspect(snapshot.hasData && !snapshot.data!.exists);

          goToNewPage((snapshot.data!.data() as Map<String, dynamic>), context);
        }

        return const Scaffold(
          backgroundColor: kSecondBlue,
        );
      },
    );
  }
}
