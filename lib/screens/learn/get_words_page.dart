import 'dart:collection';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/screens/learn/learn_page.dart';
import 'package:easy_peasy/screens/main/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:flutter/material.dart';

class GetWordsPage extends StatefulWidget {
  const GetWordsPage({Key? key}) : super(key: key);

  @override
  State<GetWordsPage> createState() => _GetWordsPageState();
}

class _GetWordsPageState extends State<GetWordsPage> {
  late List<String> wordsList;
  late Map<String, dynamic> data;
  late Map<String, dynamic> fullDataWords;
  late Future<DocumentSnapshot> _dataFuture;
  late User _user;

  @override
  void initState() {
    firebaseRequest();
    super.initState();
  }

  Future<void> firebaseRequest() async {
    _user = FirebaseAuth.instance.currentUser!;

    _dataFuture = FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .collection('dictionary')
        .doc('dictionary')
        .get();
  }

  Future<void> setWordsInList(Map<String, dynamic> snapshot) async {
    wordsList = [];
    fullDataWords = {};

    for (var element in snapshot.entries) {
      wordsList.add(element.key);
    }
    wordsList.shuffle();
    Map<String, dynamic> temp = {};

    for (var element in wordsList) {
      temp.addAll({element: snapshot[element]});
    }

    fullDataWords = Map.fromEntries(
        temp.entries.toList()..sort((k1, k2) => k1.value.compareTo(k2.value)));
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
      future: _dataFuture,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: kSecondBlue,
            body: SafeArea(
              child: Center(
                child: Text(
                  "Ошибка " +
                      snapshot.hasError.hashCode.toString() +
                      '\n' +
                      snapshot.error.toString(),
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
        if (snapshot.data == null) {
          return const Scaffold(
            backgroundColor: kSecondBlue,
          );
        }
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
                        fontSize: getProportionateScreenWidth(24),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Text(
                      'Добавляй новые слова для изучения\nво вкладке «Категории»\n',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kMainTextColor,
                        fontSize: getProportionateScreenWidth(20),
                        fontWeight: FontWeight.w400,
                      ),
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
                          fontSize: getProportionateScreenWidth(16),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
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
                          fontSize: getProportionateScreenWidth(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          goToNewPage((snapshot.data!.data() as Map<String, dynamic>), context);
        }

        return const Scaffold(
          backgroundColor: kSecondBlue,
        );
      },
    );
  }
}
