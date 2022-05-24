import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/screens/learn/learn_page.dart';
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
  late Future<DocumentSnapshot> _dataStream;

  @override
  void initState() {
    firebaseRequest();
    super.initState();
  }

  Future<void> firebaseRequest() async {
    User user = FirebaseAuth.instance.currentUser!;
    _dataStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('dictionary')
        .doc('dictionary')
        .get();
  }

  Future<void> setWordsInList(Map<String, dynamic> snapshot) async {
    wordsList = [];
    for (var element in snapshot.entries) {
      wordsList.add(element.key);
    }
    inspect(wordsList);
  }

  Future<void> goToNewPage(
      Map<String, dynamic> snapshot, BuildContext context) async {
    await setWordsInList(snapshot);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LearnPage(
          wordsList: List<String>.from(wordsList),
        ),
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

        if (snapshot.connectionState == ConnectionState.done) {
          goToNewPage(
              (snapshot.data!.data() as Map<String, dynamic>)['data'], context);
          // setWordsInList(
          //     (snapshot.data!.data() as Map<String, dynamic>)['data']);
          // inspect(wordsList);
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(
          //     builder: (context) => LearnPage(
          //       wordsList: List<String>.from(wordsList),
          //     ),
          //   ),
          // );
        }

        return const Scaffold(
          backgroundColor: kSecondBlue,
        );
      },
    );
  }
}
