import 'package:easy_peasy/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WordsChoice extends StatelessWidget {
  final String name;
  final List<String> words;
  const WordsChoice({Key? key, required this.name, required this.words})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainPurple,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: kWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                    children: words.map((word) {
                  return Text(
                    word,
                    style: const TextStyle(
                      color: kWhite,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  );
                }).toList()),
                const SizedBox(
                  height: 80,
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
