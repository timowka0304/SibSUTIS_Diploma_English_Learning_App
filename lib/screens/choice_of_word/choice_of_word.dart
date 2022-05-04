import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/models/word_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcard/tcard.dart';
import 'package:flip_card/flip_card.dart';
import 'package:http/http.dart' as http;

class WordsChoice extends StatefulWidget {
  final List<Word> wordsList;
  final Map<String, String> headersTranslate;

  const WordsChoice({
    Key? key,
    required this.wordsList,
    required this.headersTranslate,
  }) : super(key: key);

  @override
  State<WordsChoice> createState() => _WordsChoiceState();
}

class LoadingIndicatorDialog {
  static final LoadingIndicatorDialog _singleton =
      LoadingIndicatorDialog._internal();
  late BuildContext _context;
  bool isDisplayed = false;

  factory LoadingIndicatorDialog() {
    return _singleton;
  }

  LoadingIndicatorDialog._internal();

  show(BuildContext context) {
    if (isDisplayed) {
      return;
    }
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _context = context;
          isDisplayed = true;
          return WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
          );
        });
  }

  dismiss() {
    if (isDisplayed) {
      Navigator.of(_context).pop();
      isDisplayed = false;
    }
  }
}

class _WordsChoiceState extends State<WordsChoice> {
  Future<void> playSound(
    String soundName,
    Map<String, String> headersTranslate,
    BuildContext context,
  ) async {
    LoadingIndicatorDialog().show(context);

    final urlSound = Uri.parse(
        'https://developers.lingvolive.com/api/v1/Sound?dictionaryName=LingvoUniversal (En-Ru)&fileName=$soundName');
    final resultSound = await jsonDecode((await http.get(
      urlSound,
      headers: headersTranslate,
    ))
        .body);

    final player = AudioCache();
    await player.playBytes(base64Decode(resultSound));

    LoadingIndicatorDialog().dismiss();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = List.generate(
      widget.wordsList.length,
      (index) => FlipCard(
        speed: 1000,
        onFlipDone: (status) {},
        direction: FlipDirection.HORIZONTAL,
        front: Card(
          elevation: 4,
          shadowColor: kMainTextColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          color: kWhite,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.wordsList[index].wordEn,
                  style: TextStyle(
                      color: kMainTextColor,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 20,
                ),
                widget.wordsList[index].audioFile == ''
                    ? Container()
                    : GestureDetector(
                        onTap: () => {
                          playSound(widget.wordsList[index].audioFile,
                              widget.headersTranslate, context)
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.wordsList[index].transcription,
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
                      ),
              ],
            ),
          ),
        ),
        back: Card(
          elevation: 4,
          shadowColor: kMainTextColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          color: kWhite,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.wordsList[index].wordRu,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: kMainTextColor,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.wordsList[index].example,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: kMainTextColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: kSecondBlue,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TCard(
                  cards: cards,
                ),
                // Text(
                //   widget.name,
                //   style: const TextStyle(
                //     color: kWhite,
                //     fontWeight: FontWeight.w600,
                //     fontSize: 20,
                //   ),
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                // Column(
                //     children: widget.words.map((word) {
                //   return Text(
                //     word,
                //     style: const TextStyle(
                //       color: kWhite,
                //       fontWeight: FontWeight.w400,
                //       fontSize: 16,
                //     ),
                //   );
                // }).toList()),
                // const SizedBox(
                //   height: 80,
                // ),
                const SizedBox(
                  height: 60,
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
                    primary: kWhite,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Назад',
                    style: TextStyle(
                      color: kMainTextColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
