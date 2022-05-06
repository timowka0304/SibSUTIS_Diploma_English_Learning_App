import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/models/word_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcard/tcard.dart';
import 'package:flip_card/flip_card.dart';
import 'package:http/http.dart' as http;

class WordsChoice extends StatefulWidget {
  final List<String> wordsList;

  const WordsChoice({
    Key? key,
    required this.wordsList,
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
        barrierColor: kSecondBlue.withOpacity(0.2),
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
                    child: CircularProgressIndicator(
                      color: kMainPink,
                    ),
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
  late Future<void> dataFuture;

  var datas = <Word>[];

  int cardIndex = 0;
  Word word = Word(
      wordEn: '', wordRu: '', transcription: '', audioFile: '', example: '');

  late Map<String, String> headersTranslate;
  late List<Word> finalWordsList;
  late http.Response bearerToken;

  Future<void> getFirstWords(int index) async {
    //   final results = await Future.wait([
    //     getWord(widget.wordsList, index).then((value) {
    //     word = value;
    //   }),
    //     getWord(widget.wordsList, index += 1).then((value) {
    //     word = value;
    //   }),getWord(widget.wordsList, index += 1).then((value) {
    //     word = value;
    //   }),
    // ]);
    await getWord(widget.wordsList, index).then((value) {
      word = value;
    });
  }

  @override
  void initState() {
    super.initState();
    dataFuture = initial();
  }

  Future<void> initial() async {
    bearerToken = await getAuthToken();
    for (int i = 0; i < 1; i++) {
      await getFirstWords(i);
      datas.add(word);
      cardIndex++;
      print('cardIndex = $cardIndex');
    }
    inspect(datas);
  }

  Future<void> swipe() async {
    datas.removeAt(0);
    print('Swipe cardIndex = $cardIndex');
    await getWord(widget.wordsList, cardIndex).then((value) => word = value);
    datas.add(word);
  }

  Future<http.Response> getAuthToken() async {
    String key =
        "ZDVlZjZhYWItZGFhZC00ZDlkLWEwOTEtYzY2MWRkYWFlZWU3OjRiZTZjMjhkNDNmZTQ1M2ZiZDZlNTUyZTBiMjhmYmI2";
    final uri =
        Uri.parse('https://developers.lingvolive.com/api/v1.1/authenticate');
    return http.post(
      uri,
      headers: {'Authorization': 'Basic ' + key},
    );
  }

  Future<Word> getWord(List<String> words, int index) async {
    headersTranslate = {'Authorization': 'Bearer ' + bearerToken.body};
    final urlWord = Uri.parse(
        'https://api.lingvolive.com/Translation/tutor-cards?text=${words[index]}&srcLang=1033&dstLang=1049');
    final response = await http.get(urlWord, headers: headersTranslate);

    if (response.body != 'null') {
      List<dynamic> resultWordInfo = await jsonDecode(response.body);
      return Word.fromJson(resultWordInfo);
    } else {
      return Word(
          wordEn: '',
          wordRu: '',
          transcription: '',
          audioFile: '',
          example: '');
    }
  }

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
    await player.playBytes(
      base64Decode(
        resultSound,
      ),
    );

    LoadingIndicatorDialog().dismiss();
  }

  @override
  Widget build(BuildContext context) {
    // List<Widget> cards = List.generate(
    //   2,
    //   (index) => FlipCard(
    //     speed: 1000,
    //     onFlipDone: (status) {},
    //     direction: FlipDirection.HORIZONTAL,
    //     front: Card(
    //       elevation: 4,
    //       shadowColor: kMainTextColor.withOpacity(0.3),
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(60),
    //       ),
    //       color: kWhite,
    //       child: Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Text(
    //               widget.wordsList[index].wordEn,
    //               style: TextStyle(
    //                   color: kMainTextColor,
    //                   fontSize: 26.sp,
    //                   fontWeight: FontWeight.w600),
    //             ),
    //             const SizedBox(
    //               height: 20,
    //             ),
    //             widget.wordsList[index].audioFile == ''
    //                 ? Container()
    //                 : GestureDetector(
    //                     onTap: () => {
    //                       playSound(widget.wordsList[index].audioFile,
    //                           widget.headersTranslate, context)
    //                     },
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: <Widget>[
    //                         Text(
    //                           widget.wordsList[index].transcription,
    //                           style: TextStyle(
    //                             fontSize: 20.sp,
    //                             color: kMainPurple,
    //                             fontWeight: FontWeight.w400,
    //                           ),
    //                         ),
    //                         const SizedBox(
    //                           width: 10,
    //                         ),
    //                         const Icon(
    //                           Icons.volume_up_rounded,
    //                           color: kMainPurple,
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //           ],
    //         ),
    //       ),
    //     ),
    //     back: Card(
    //       elevation: 4,
    //       shadowColor: kMainTextColor.withOpacity(0.3),
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(60),
    //       ),
    //       color: kWhite,
    //       child: Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Text(
    //               widget.wordsList[index].wordRu,
    //               textAlign: TextAlign.center,
    //               style: TextStyle(
    //                   color: kMainTextColor,
    //                   fontSize: 26.sp,
    //                   fontWeight: FontWeight.w600),
    //             ),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             Text(
    //               widget.wordsList[index].example,
    //               textAlign: TextAlign.center,
    //               style: TextStyle(
    //                   color: kMainTextColor,
    //                   fontSize: 20.sp,
    //                   fontWeight: FontWeight.w400),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    List<Widget> renderCards() {
      render(Word data, int index) {
        return SizedBox(
          height: 250,
          width: 250,
          child: Card(
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
                  ElevatedButton(
                    onPressed: () {
                      setState(
                        () {
                          cardIndex++;
                          dataFuture = swipe();
                        },
                      );
                      inspect(datas);
                    },
                    child: Text("swipe"),
                  ),
                  Text(
                    data.wordEn,
                    style: TextStyle(
                        color: kMainTextColor,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  data.audioFile == ''
                      ? Container()
                      : GestureDetector(
                          onTap: () => {
                            playSound(data.audioFile, headersTranslate, context)
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                data.transcription,
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
        );
      }

      return datas.reversed
          .map((data) => render(data, datas.indexOf(data)))
          .toList();
    }

    return FutureBuilder(
      future: dataFuture,
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
                child: Stack(
                  children: renderCards(),
                ),
                // child: TCard(
                //   cards: renderCards(),
                //   controller: _controller,
                //   onForward: (_, info) {
                //     if (info.direction == SwipDirection.Right) {
                //       print('like');
                //       setState(() {
                //         cardIndex++;
                //         dataFuture = swipe();
                //       });
                //       inspect(datas);
                //     } else {
                //       print('dislike');
                //       setState(() {
                //         cardIndex++;
                //         dataFuture = swipe();
                //       });
                //       inspect(datas);
                //     }
                //   },
                // ),
              ),
              // child: Stack(
              //   children: renderCards(),
              // ),
            ),
          );
        }
      },
    );
  }
}
