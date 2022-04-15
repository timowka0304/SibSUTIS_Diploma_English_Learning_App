import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:easy_peasy/components/others/firebase_storage.dart';
import 'package:easy_peasy/components/others/shared_pref.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:easy_peasy/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translator/translator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final translator = GoogleTranslator();
  late int beginersCount;
  late int intermediateCount;
  late int filmsCount;
  late Map<String, dynamic> wordsImage;
  late Map<String, dynamic> dictionary;

  Future<void> generateCards() async {
    await getDictionaryJSON().then(
      ((value) async {
        final response = await fetchJSON(value);
        Map<String, dynamic> dictionary =
            json.decode(utf8.decode(response.bodyBytes));
        beginersCount = (dictionary["begginer"] as Map<String, dynamic>).length;
        intermediateCount =
            (dictionary["intermediate"] as Map<String, dynamic>).length;
        filmsCount = (dictionary["films"] as Map<String, dynamic>).length;
      }),
    );
    await getCategoriesInfo().then((value) async {
      if (value == null) {
        wordsImage = {};
        await getImagesForBegginers();
        await getImagesForIntermediate();
        await getImagesForFilms();
        await storeCategoriesInfo(json.encode(wordsImage));
      } else {
        wordsImage = {};
        wordsImage = json.decode(await getCategoriesImages());
      }
    });
  }

  Future<http.Response> fetchJSON(String value) async {
    final uri = Uri.parse(value);
    return http.get(uri);
  }

  Future<void> getImagesForFilms() async {
    for (String element in nameOfCategoryForFilms.keys) {
      String url =
          await getFilmsImage(nameOfCategoryForFilms[element].toString());
      wordsImage[element] = url;
    }
  }

  Future<void> getImagesForBegginers() async {
    for (String element in nameOfCategoryForBeginner.keys) {
      String url =
          await searchImage(nameOfCategoryForBeginner[element].toString());
      wordsImage[element] = url;
    }
  }

  Future<void> getImagesForIntermediate() async {
    for (String element in nameOfCategoryForIntermediate.keys) {
      String url =
          await searchImage(nameOfCategoryForIntermediate[element].toString());
      wordsImage[element] = url;
    }
  }

  Future<http.Response> fetchImageByKeyword(String keyWord) async {
    String apiKey = 'Ppw1eG0YzUaD-rRKTyLO3UXnrpLMK8Vi9qAFRQCoRmI';
    final uri = Uri.parse(
        'https://api.unsplash.com/search/photos/?client_id=$apiKey&query=${keyWord.toLowerCase()}&page=1');

    return http.get(uri);
  }

  Future<String> searchImage(String keyWord) async {
    final response = await fetchImageByKeyword(keyWord);

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return (result["results"][0]["urls"]["small"]);
    } else {
      return "http://via.placeholder.com/200x150";
    }
  }

  Map<String, String> nameOfCategoryForFilms = {
    'Во все тяжкие': 'breaking_bad',
    'Друзья': 'friends',
    'Игра престолов': 'game_of_thrones',
    'Анатомия страсти': 'grace_anatomy',
    'Гарри Поттер': 'harry_potter-min',
    'Очень странные дела': 'stranger_things'
  };

  Map<String, String> nameOfCategoryForBeginner = {
    'Погода': 'Weather',
    'Одежда': 'Clothing',
    'Природа': 'Nature',
    'Еда': 'Food',
    'Город': 'City',
    'Страны и столицы': 'Countries and Capitals'
  };

  Map<String, String> nameOfCategoryForIntermediate = {
    'Внешность': 'Appearance',
    'Одежда и мода': 'Clothes and Fashion',
    'Характер': 'Character',
    'Блюда': 'Dishes',
    'Путешествия': 'Trips',
    'Транспорт': 'Transport'
  };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: generateCards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: kMainPink,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  Text(
                    "Подождите несколько секунд.\nПолучаем карточки с сервера ...",
                    style: TextStyle(
                        color: kMainTextColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: kSecondBlue,
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: ScreenUtil().setHeight(50),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(30),
                      ),
                      child: Text(
                        "Начальный уровень:",
                        style: TextStyle(
                            color: kMainTextColor,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(150),
                      child: Column(children: [
                        Expanded(
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(20),
                              ScreenUtil().setHeight(0),
                              ScreenUtil().setWidth(20),
                              ScreenUtil().setHeight(0),
                            ),
                            physics: const BouncingScrollPhysics(),
                            itemCount: beginersCount,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: ScreenUtil().setWidth(20),
                              );
                            },
                            itemBuilder: (context, index) {
                              return categoryCard("Beginer", index);
                            },
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(50),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(30),
                      ),
                      child: Text(
                        "Средний уровень:",
                        style: TextStyle(
                            color: kMainTextColor,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(150),
                      child: Column(children: [
                        Expanded(
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(20),
                              ScreenUtil().setHeight(0),
                              ScreenUtil().setWidth(20),
                              ScreenUtil().setHeight(0),
                            ),
                            physics: const BouncingScrollPhysics(),
                            itemCount: intermediateCount,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: ScreenUtil().setWidth(20),
                              );
                            },
                            itemBuilder: (context, index) {
                              return categoryCard("Intermediate", index);
                            },
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(50),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(30),
                      ),
                      child: Text(
                        "По сериалам и фильмам:",
                        style: TextStyle(
                            color: kMainTextColor,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(150),
                      child: Column(children: [
                        Expanded(
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(20),
                              ScreenUtil().setHeight(0),
                              ScreenUtil().setWidth(20),
                              ScreenUtil().setHeight(0),
                            ),
                            physics: const BouncingScrollPhysics(),
                            itemCount: filmsCount,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: ScreenUtil().setWidth(20),
                              );
                            },
                            itemBuilder: (context, index) {
                              return categoryCard("Films", index);
                            },
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget categoryCard(String typeList, int index) {
    {
      return SizedBox(
        width: ScreenUtil().setWidth(180),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  spreadRadius: 5,
                  blurRadius: 7, // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: CachedNetworkImage(
                    width: ScreenUtil().setWidth(180),
                    fit: BoxFit.cover,
                    imageUrl: typeList == "Beginer"
                        ? wordsImage[
                                nameOfCategoryForBeginner.keys.elementAt(index)]
                            .toString()
                        : typeList == "Intermediate"
                            ? wordsImage[nameOfCategoryForIntermediate.keys
                                    .elementAt(index)]
                                .toString()
                            : typeList == "Films"
                                ? wordsImage[nameOfCategoryForFilms.keys
                                        .elementAt(index)]
                                    .toString()
                                : "https://via.placeholder.com/200x150/595ABA/595ABA",
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            LinearProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    kMainPink.withOpacity(0.3)),
                                backgroundColor: kWhite,
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setWidth(0),
                      ScreenUtil().setHeight(10),
                      ScreenUtil().setWidth(0),
                      ScreenUtil().setHeight(10),
                    ),
                    child: typeList == "Beginer"
                        ? Text(
                            nameOfCategoryForBeginner.keys.elementAt(index),
                            style: TextStyle(
                              color: kMainTextColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                            ),
                          )
                        : typeList == "Intermediate"
                            ? Text(
                                nameOfCategoryForIntermediate.keys
                                    .elementAt(index),
                                style: TextStyle(
                                  color: kMainTextColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                ),
                              )
                            : typeList == "Films"
                                ? Text(
                                    nameOfCategoryForFilms.keys
                                        .elementAt(index),
                                    style: TextStyle(
                                      color: kMainTextColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.sp,
                                    ),
                                  )
                                : null),
              ],
            ),
          ),
        ),
      );
    }
  }
}
