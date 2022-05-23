import 'dart:math';

import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:confetti/confetti.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key, required this.cardName}) : super(key: key);
  final String cardName;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late ConfettiController _controller;

  @override
  void initState() {
    _controller = ConfettiController(
      duration: const Duration(seconds: 5),
    );
    _controller.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondBlue,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '«${widget.cardName}»',
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
                    'Карточка завершена!\nПоздравляем!\n',
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
                        ScreenUtil().setWidth(80),
                        ScreenUtil().setHeight(40),
                      ),
                      maximumSize: Size(
                        ScreenUtil().setWidth(100),
                        ScreenUtil().setHeight(40),
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      primary: kMainPurple,
                    ),
                    onPressed: () {
                      _controller.stop();
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
                            }),
                      );
                    },
                    child: Text(
                      'Готово',
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _controller,
                blastDirection: pi / 2,
                blastDirectionality: BlastDirectionality.directional,
                minBlastForce: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
