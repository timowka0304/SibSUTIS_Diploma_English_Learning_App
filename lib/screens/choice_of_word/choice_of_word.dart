import 'package:easy_peasy/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcard/tcard.dart';
import 'package:flip_card/flip_card.dart';

class WordsChoice extends StatefulWidget {
  final String name;
  final List<String> words;
  const WordsChoice({Key? key, required this.name, required this.words})
      : super(key: key);

  @override
  State<WordsChoice> createState() => _WordsChoiceState();
}

class _WordsChoiceState extends State<WordsChoice> {
  @override
  Widget build(BuildContext context) {
    List<Widget> cards = List.generate(
      widget.words.length,
      (index) => FlipCard(
        speed: 1000,
        onFlipDone: (status) {
          print(status);
        },
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
                  widget.words[index],
                  style: TextStyle(
                      color: kMainTextColor,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () => print("Sound"),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "sound",
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: kMainPurple,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Icon(
                        Icons.volume_up_rounded,
                        color: kMainPurple,
                      )
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
                  widget.words[index],
                  style: TextStyle(
                      color: kMainTextColor,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w600),
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
