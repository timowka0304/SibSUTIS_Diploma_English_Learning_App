import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_peasy/size_config.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({Key? key}) : super(key: key);

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  late Stream<QuerySnapshot> _dataStream;

  @override
  void initState() {
    firebaseRequest();
    super.initState();
  }

  Future<void> firebaseRequest() async {
    _dataStream = FirebaseFirestore.instance
        .collection('users')
        .orderBy(
          'numberOfLearnedWords',
          descending: true,
        )
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _dataStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
        } else {
          return Scaffold(
            backgroundColor: kSecondBlue,
            body: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                getProportionateScreenWidth(15),
                                getProportionateScreenHeight(25),
                                getProportionateScreenWidth(15),
                                getProportionateScreenHeight(30),
                              ),
                              child: TextButton(
                                style: ButtonStyle(
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                    return kMainPurple.withOpacity(0.1);
                                  }),
                                ),
                                child: Text(
                                  'Назад',
                                  style: TextStyle(
                                    color: kMainTextColor,
                                    fontSize: getProportionateScreenWidth(16),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const MainScreen(
                                        pageIndex: 2,
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
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        children: snapshot.data!.docs.map(
                          (doc) {
                            return Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: getProportionateScreenWidth(400),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: CachedNetworkImage(
                                            width: getProportionateScreenWidth(
                                                100),
                                            fit: BoxFit.cover,
                                            imageUrl: doc.get('profileImg'),
                                            progressIndicatorBuilder: (
                                              context,
                                              url,
                                              downloadProgress,
                                            ) =>
                                                LinearProgressIndicator(
                                              minHeight:
                                                  getProportionateScreenWidth(
                                                      100),
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                kMainPink.withOpacity(0.3),
                                              ),
                                              backgroundColor: kWhite,
                                              value: downloadProgress.progress,
                                            ),
                                            errorWidget: (
                                              context,
                                              url,
                                              error,
                                            ) =>
                                                const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: getProportionateScreenWidth(20),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            doc.get('username'),
                                            style: TextStyle(
                                              color: kMainTextColor,
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      18),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    20),
                                          ),
                                          Container(
                                            height:
                                                getProportionateScreenHeight(
                                                    30),
                                            width: getProportionateScreenWidth(
                                                150),
                                            decoration: BoxDecoration(
                                              color: kMainPink,
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                                        getProportionateScreenWidth(
                                                            16),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: doc
                                                          .get(
                                                              'numberOfLearnedWords')
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: kWhite,
                                                        fontWeight:
                                                            FontWeight.w800,
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
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
