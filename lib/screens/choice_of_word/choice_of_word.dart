import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/models/word_model.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flip_card/flip_card.dart';
import 'package:http/http.dart' as http;
import 'package:slider_button/slider_button.dart';

class WordsChoice extends StatefulWidget {
  final List<String> wordsList;

  const WordsChoice({
    Key? key,
    required this.wordsList,
  }) : super(key: key);

  @override
  State<WordsChoice> createState() => _WordsChoiceState();
}

class TagWidget extends StatelessWidget {
  const TagWidget({
    Key? key,
    required this.text,
    required this.side,
  }) : super(key: key);

  final String text;
  final String side;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: kMainPink,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: kMainTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          child: Row(
            children: [
              side == 'left'
                  ? const Icon(
                      Icons.arrow_back_rounded,
                      color: kMainTextColor,
                    )
                  : Text(text),
              const SizedBox(
                width: 5,
              ),
              side == 'left'
                  ? Text(text)
                  : const Icon(
                      Icons.arrow_forward_rounded,
                      color: kMainTextColor,
                    ),
            ],
          ),
        ),
      ),
    );
  }
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

  late bool _flipped = false;
  late bool _returnFlipped = false;
  late bool _visible = false;

  Future<void> getFirstWords(int index) async {
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
      // print('cardIndex = $cardIndex');
    }
    // inspect(datas);
  }

  Future<void> swipe() async {
    datas.removeAt(0);
    // print('Swipe cardIndex = $cardIndex');
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

  Future<void> playSound(String soundName, Map<String, String> headersTranslate,
      BuildContext context) async {
    LoadingIndicatorDialog().show(context);

    final urlSound = Uri.parse(
        'https://developers.lingvolive.com/api/v1/Sound?dictionaryName=LingvoUniversal (En-Ru)&fileName=$soundName');
    final resultSound = await jsonDecode((await http.get(
      urlSound,
      headers: headersTranslate,
    ))
        .body);

    final player = AudioPlayer();
    await player.playBytes(
      base64Decode(
        resultSound,
      ),
    );

    LoadingIndicatorDialog().dismiss();
  }

  @override
  Widget build(BuildContext context) {
    FlipCardController _controller = FlipCardController();
    FlipCardController _controllerFeedback = FlipCardController();

    List<Widget> renderCards() {
      render(Word data, int index) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DragTarget<Word>(
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        // color: kMainPurple,
                      );
                    },
                    // hitTestBehavior: HitTestBehavior.opaque,
                    onAccept: (_) {
                      setState(
                        () {
                          _flipped = false;
                          _returnFlipped = false;
                          _visible = false;
                          cardIndex++;
                          dataFuture = swipe();
                          print('dislike');
                        },
                      );
                    },
                  ),
                ),
                const Expanded(
                  flex: 3,
                  child: SizedBox.shrink(),
                ),
                Expanded(
                  flex: 2,
                  child: DragTarget<Word>(
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        // color: kMainPink,
                      );
                    },
                    onAccept: (data) {
                      setState(
                        () {
                          _flipped = false;
                          _returnFlipped = false;
                          cardIndex++;
                          dataFuture = swipe();
                          print('like');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Draggable(
              childWhenDragging: Container(
                height: 350,
                width: 350,
                color: kSecondBlue,
              ),
              data: data,
              onDragStarted: () {
                setState(() {
                  _visible = true;
                });
              },
              onDragEnd: (_) {
                setState(() {
                  _visible = false;
                });
              },
              onDraggableCanceled: (_, __) {
                _flipped
                    ? setState(() {
                        _returnFlipped = true;
                      })
                    : setState(() {
                        _returnFlipped = false;
                      });
                print('Flipped: $_flipped');
                print('Return Flipped: $_returnFlipped');
              },
              feedback: !_flipped
                  ? SizedBox(
                      height: 350,
                      width: 350,
                      child: Stack(
                        children: [
                          Card(
                            elevation: 6,
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
                                            playSound(data.audioFile,
                                                headersTranslate, context)
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                          // const Positioned(
                          //   top: 40,
                          //   right: 40,
                          //   child: TagWidget(
                          //     text: 'Добавить',
                          //     side: 'right',
                          //   ),
                          // ),
                          // const Positioned(
                          //   top: 40,
                          //   left: 40,
                          //   child: TagWidget(
                          //     text: 'Пропустить',
                          //     side: 'left',
                          //   ),
                          // ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 350,
                      width: 350,
                      child: Stack(
                        children: [
                          Card(
                            elevation: 6,
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
                                    data.wordRu,
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
                                    data.example,
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
                          // const Positioned(
                          //   top: 40,
                          //   right: 40,
                          //   child: TagWidget(
                          //     text: 'Добавить',
                          //     side: 'right',
                          //   ),
                          // ),
                          // const Positioned(
                          //   top: 40,
                          //   left: 40,
                          //   child: TagWidget(
                          //     text: 'Пропустить',
                          //     side: 'left',
                          //   ),
                          // ),
                        ],
                      ),
                    ),
              child: SizedBox(
                height: 350,
                width: 350,
                child: FlipCard(
                  controller: _controller,
                  speed: 1000,
                  onFlipDone: (status) {
                    setState(() {
                      _flipped = !_flipped;
                    });
                    print('onFlipDone: $_flipped');
                  },
                  direction: FlipDirection.HORIZONTAL,
                  front: !_returnFlipped
                      ? Card(
                          elevation: 3,
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
                                          playSound(data.audioFile,
                                              headersTranslate, context)
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                        )
                      : Card(
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
                                // Text(
                                //   data.wordEn,
                                //   style: TextStyle(
                                //       color: kMainTextColor,
                                //       fontSize: 26.sp,
                                //       fontWeight: FontWeight.w600),
                                // ),
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                Text(
                                  data.wordRu,
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
                                  data.example,
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
                  back: _returnFlipped
                      ? Card(
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
                                          playSound(data.audioFile,
                                              headersTranslate, context)
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                        )
                      : Card(
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
                                // Text(
                                //   data.wordEn,
                                //   style: TextStyle(
                                //       color: kMainTextColor,
                                //       fontSize: 26.sp,
                                //       fontWeight: FontWeight.w600),
                                // ),
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                Text(
                                  data.wordRu,
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
                                  data.example,
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
              ),
            ),
            Positioned(
              top: 100,
              child: Container(
                width: 320,
                child: AnimatedOpacity(
                  opacity: _visible ? 1 : 0,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 400),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Transform.rotate(
                        angle: -0.2,
                        child: const TagWidget(
                          text: 'Пропустить',
                          side: 'left',
                        ),
                      ),
                      Transform.rotate(
                        angle: 0.2,
                        child: const TagWidget(
                          text: 'Добавить',
                          side: 'right',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
                  children: [
                    Padding(
                      padding: EdgeInsets.all(30),
                      child: Row(
                        children: [
                          Text("Назад"),
                          Text("data"),
                        ],
                      ),
                    ),
                    Stack(
                      children: renderCards(),
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
