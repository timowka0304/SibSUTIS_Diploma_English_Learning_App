import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_peasy/components/others/dialogs.dart';
import 'package:easy_peasy/components/others/firebase_storage.dart';
import 'package:easy_peasy/components/others/loading_indicator.dart';
import 'package:easy_peasy/components/others/shared_pref.dart';
import 'package:easy_peasy/components/others/tag_widget.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/models/word_model.dart';
import 'package:easy_peasy/screens/choice_of_word/result_page.dart';
import 'package:easy_peasy/screens/main/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:http/http.dart' as http;
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:easy_peasy/size_config.dart';

class WordsChoice extends StatefulWidget {
  const WordsChoice({
    Key? key,
    required this.wordsList,
    required this.cardName,
  }) : super(key: key);

  final List<String> wordsList;
  final String cardName;

  @override
  State<WordsChoice> createState() => _WordsChoiceState();
}

class _WordsChoiceState extends State<WordsChoice> {
  late Future<void> dataFuture;

  var datas = <Word>[];

  int cardIndex = -1;
  Word word = Word(
      wordEn: '', wordRu: '', transcription: '', audioFile: '', example: '');

  late Map<String, String> headersTranslate;
  late List<Word> finalWordsList;
  late http.Response bearerToken;

  late bool _flipped = false;
  late bool _returnFlipped = false;
  late bool _visible = false;
  late bool _hintVisible;

  late User _user;

  @override
  void initState() {
    dataFuture = initial();
    super.initState();
  }

  Future<void> initial() async {
    bearerToken = await getAuthToken();
    _user = FirebaseAuth.instance.currentUser!;
    for (int i = 0; i < 1; i++) {
      await getFirstWords(i);
      datas.add(word);
      cardIndex++;
    }
    await getDragHint().then(
      (value) {
        _hintVisible = value;
      },
    );
  }

  Future<void> getFirstWords(int index) async {
    await getWord(widget.wordsList, index).then(
      (value) {
        word = value;
      },
    );
  }

  Future<void> swipe(String direction) async {
    String wordEn = datas[0].wordEn;
    datas.removeAt(0);

    direction == 'like' ? await addWordToDic(_user, wordEn.trim()) : null;

    if (cardIndex == widget.wordsList.length) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ResultPage(
            cardName: widget.cardName,
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
    } else {
      await getWord(widget.wordsList, cardIndex).then(
        (value) => word = value,
      );
      datas.add(word);
    }
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

    List<Widget> renderCards() {
      render(Word data, int index) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: DragTarget<Word>(
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                      );
                    },
                    onAccept: (_) {
                      setState(
                        () {
                          _flipped = false;
                          _returnFlipped = false;
                          cardIndex++;
                          dataFuture = swipe('dislike');
                        },
                      );
                    },
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: SizedBox.shrink(),
                ),
                Expanded(
                  flex: 1,
                  child: DragTarget<Word>(
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                      );
                    },
                    onAccept: (data) {
                      setState(
                        () {
                          _flipped = false;
                          _returnFlipped = false;
                          cardIndex++;
                          dataFuture = swipe('like');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Draggable(
              childWhenDragging: Container(),
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
              },
              feedback: !_flipped
                  ? SizedBox(
                      height: getProportionateScreenHeight(350),
                      width: getProportionateScreenWidth(350),
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
                                      fontSize: getProportionateScreenWidth(26),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(20),
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
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          22),
                                                  color: kMainPurple,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    getProportionateScreenWidth(
                                                        10),
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
                        ],
                      ),
                    )
                  : SizedBox(
                      height: getProportionateScreenHeight(350),
                      width: getProportionateScreenWidth(350),
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
                                      fontSize: getProportionateScreenWidth(26),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(10),
                                  ),
                                  Text(
                                    data.example,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: kMainTextColor,
                                      fontSize: getProportionateScreenWidth(22),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              child: SizedBox(
                height: getProportionateScreenHeight(350),
                width: getProportionateScreenWidth(350),
                child: FlipCard(
                  controller: _controller,
                  speed: 1000,
                  onFlipDone: (status) {
                    setState(() {
                      _flipped = !_flipped;
                    });
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
                                    fontSize: getProportionateScreenWidth(26),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(20),
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
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        22),
                                                color: kMainPurple,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  getProportionateScreenWidth(
                                                      10),
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
                                Text(
                                  data.wordRu,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kMainTextColor,
                                    fontSize: getProportionateScreenWidth(26),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(10),
                                ),
                                Text(
                                  data.example,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kMainTextColor,
                                    fontSize: getProportionateScreenWidth(22),
                                    fontWeight: FontWeight.w400,
                                  ),
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
                                    fontSize: getProportionateScreenWidth(26),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(20),
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
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        22),
                                                color: kMainPurple,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  getProportionateScreenWidth(
                                                      10),
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
                                Text(
                                  data.wordRu,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kMainTextColor,
                                    fontSize: getProportionateScreenWidth(26),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(10),
                                ),
                                Text(
                                  data.example,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kMainTextColor,
                                    fontSize: getProportionateScreenWidth(22),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ),
            Positioned(
              top: getProportionateScreenHeight(120),
              // ignore: sized_box_for_whitespace
              child: Container(
                width: getProportionateScreenWidth(320),
                child: AnimatedOpacity(
                  opacity: _visible && _hintVisible ? 1 : 0,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 400,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Transform.rotate(
                        angle: -0.2,
                        child: const TagWidget(
                          text: 'Не учить',
                          side: 'left',
                        ),
                      ),
                      Transform.rotate(
                        angle: 0.2,
                        child: const TagWidget(
                          text: 'Учить',
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
                      padding: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(15),
                        getProportionateScreenHeight(25),
                        getProportionateScreenWidth(15),
                        getProportionateScreenHeight(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      return kMainPurple.withOpacity(0.1);
                                    },
                                  ),
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
                              ),
                              Row(
                                children: [
                                  AnimatedToggleSwitch<bool>.dual(
                                    current: _hintVisible,
                                    first: false,
                                    second: true,
                                    dif: 0,
                                    borderColor: Colors.transparent,
                                    innerColor: kMainPurple.withOpacity(0.3),
                                    borderWidth: 0,
                                    height: getProportionateScreenWidth(15),
                                    indicatorSize: Size(
                                      getProportionateScreenWidth(15),
                                      getProportionateScreenWidth(15),
                                    ),
                                    onChanged: (value) => setState(
                                      () {
                                        _hintVisible = value;
                                        storeDragHint(value);
                                      },
                                    ),
                                    colorBuilder: (value) => value
                                        ? kMainPurple
                                        : kMainPurple.withOpacity(0.3),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(10),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.info,
                                        color: kMainPurple),
                                    splashRadius: 15,
                                    splashColor: kWhite.withOpacity(0.5),
                                    highlightColor: kWhite.withOpacity(0.5),
                                    onPressed: () {
                                      showInfoDialog(context);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${cardIndex + 1} / ${widget.wordsList.length}',
                                style: TextStyle(
                                  color: kMainTextColor,
                                  fontSize: getProportionateScreenWidth(16),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  getProportionateScreenWidth(15),
                                  getProportionateScreenHeight(0),
                                  getProportionateScreenWidth(15),
                                  getProportionateScreenHeight(0),
                                ),
                                child: LinearProgressIndicator(
                                  value:
                                      (cardIndex + 1) / widget.wordsList.length,
                                  color: kMainPurple,
                                  backgroundColor: kMainPurple.withOpacity(0.3),
                                ),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(30),
                              ),
                            ],
                          ),
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
