import 'dart:convert';
import 'dart:developer';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_peasy/components/others/dialogs.dart';
import 'package:easy_peasy/components/others/shared_pref.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/models/word_model.dart';
import 'package:easy_peasy/screens/main/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class LearnPage extends StatefulWidget {
  const LearnPage({Key? key, required this.cardName}) : super(key: key);
  final String cardName;

  @override
  State<LearnPage> createState() => _LearnPageState();
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
        color: kWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          // side: const BorderSide(
          //   color: kMainPink,
          //   width: 1,
          // ),
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
                      size: 12,
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
                      size: 12,
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
      },
    );
  }

  dismiss() {
    if (isDisplayed) {
      Navigator.of(_context).pop();
      isDisplayed = false;
    }
  }
}

class _LearnPageState extends State<LearnPage> {
  late User _user;
  var datas = <Word>[];
  late bool _hintVisible;
  int cardIndex = 0;
  Word word = Word(
      wordEn: '', wordRu: '', transcription: '', audioFile: '', example: '');

  late Map<String, String> headersTranslate;
  late List<Word> finalWordsList;
  late List<String> wordsList;
  late http.Response bearerToken;
  late Map<String, dynamic> data;

  late Future<DocumentSnapshot> _dataStream;
  late Future<void> _dataFuture;

  late bool _flipped = false;
  late bool _returnFlipped = false;
  late bool _visible = false;

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
  }

  Future<void> initial() async {
    bearerToken = await getAuthToken();
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
    await getWord(wordsList, index).then((value) {
      word = value;
    });
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
        example: '',
      );
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

  Future<void> swipe(String direction) async {
    String wordEn = datas[0].wordEn;
    datas.removeAt(0);
    if (cardIndex == wordsList.length) {
      print("Done!");
    } else {
      print(direction);
      // direction == 'like' ? await addWordToDic(user, wordEn.trim()) : null;
      await getWord(wordsList, cardIndex).then(
        (value) => word = value,
      );
      datas.add(word);
    }
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
                          _dataFuture = swipe('dislike');
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
                          _dataFuture = swipe('like');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Draggable(
              childWhenDragging: Container(
                  ),
              data: data,
              onDragStarted: () { // TODO: 
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
              top: 120,
              child: Container(
                width: 320,
                child: AnimatedOpacity(
                  opacity: _visible && _hintVisible ? 1 : 0,
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
          data = snapshot.data!.data() as Map<String, dynamic>;
          data = data['data'];
          wordsList = [];
          for (var element in data.entries) {
            wordsList.add(element.key);
          }

          inspect(wordsList);

          _dataFuture = initial();

          return FutureBuilder(
            future: _dataFuture,
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
                            padding: const EdgeInsets.fromLTRB(15, 25, 15, 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                          return kMainPurple.withOpacity(0.1);
                                        }),
                                      ),
                                      child: Text(
                                        'Назад',
                                        style: TextStyle(
                                          color: kMainTextColor,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  const MainScreen(
                                                    pageIndex: 0,
                                                    isStart: false,
                                                  ),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
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
                                                  opacity:
                                                      animation.drive(tween),
                                                  child: child,
                                                );
                                              }),
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
                                          innerColor:
                                              kMainPurple.withOpacity(0.3),
                                          borderWidth: 0,
                                          height: 15,
                                          indicatorSize: const Size(15, 15),
                                          onChanged: (value) => setState(() {
                                            _hintVisible = value;
                                            storeDragHint(value);
                                          }),
                                          colorBuilder: (value) => value
                                              ? kMainPurple
                                              : kMainPurple.withOpacity(0.3),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.info,
                                              color: kMainPurple),
                                          splashRadius: 15,
                                          splashColor: kWhite.withOpacity(0.5),
                                          highlightColor:
                                              kWhite.withOpacity(0.5),
                                          onPressed: () {
                                            showInfoDialog(context);
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            children: renderCards(),
                            // children: const [
                            //   Text('1'),
                            //   Text('2'),
                            //   Text('3'),
                            // ],
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
