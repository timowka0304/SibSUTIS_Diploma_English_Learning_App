import 'dart:async';
import 'dart:convert';
import 'package:easy_peasy/components/others/firebase_storage.dart';
import 'package:easy_peasy/components/others/shared_pref.dart';
import 'package:easy_peasy/screens/choice_of_word/choice_of_word.dart';
import 'package:http/http.dart' as http;
import 'package:easy_peasy/constants.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_peasy/size_config.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Map<String, dynamic> wordsImage;

  late Map<String, dynamic> beginnerDictionary;
  late Map<String, dynamic> intermediateDictionary;
  late Map<String, dynamic> filmsDictionary;

  Future<void> generateCards() async {
    await getCategoriesInfo().then(
      (value) async {
        beginnerDictionary = {};
        intermediateDictionary = {};
        filmsDictionary = {};
        wordsImage = {};

        if (value == null) {
          await getDictionaryJSON().then(
            ((value) async {
              final response = await fetchJSON(value);
              Map<String, dynamic> dictionary =
                  json.decode(utf8.decode(response.bodyBytes));

              beginnerDictionary = dictionary["begginer"];
              intermediateDictionary = dictionary["intermediate"];
              filmsDictionary = dictionary["films"];
            }),
          );

          await getImagesForBegginers();
          await getImagesForIntermediate();
          await getImagesForFilms();

          await storeCategoriesInfo(
            json.encode(wordsImage),
            json.encode(beginnerDictionary),
            json.encode(intermediateDictionary),
            json.encode(filmsDictionary),
          );
        } else {
          wordsImage = json.decode(await getCategoriesImages());

          beginnerDictionary = json.decode(await getBeginersDict());
          intermediateDictionary = json.decode(await getIntermediateDict());
          filmsDictionary = json.decode(await getFilmsDict());
        }
      },
    );
  }

  Future<http.Response> fetchJSON(String value) async {
    final uri = Uri.parse(value);
    return http.get(uri);
  }

  Future<void> getImagesForBegginers() async {
    for (var element in beginnerDictionary.entries) {
      String url = await searchImage(element.value['keyword']);
      wordsImage[element.key] = url;
    }
  }

  Future<void> getImagesForIntermediate() async {
    for (var element in intermediateDictionary.entries) {
      String url = await searchImage(element.value['keyword']);
      wordsImage[element.key] = url;
    }
  }

  Future<void> getImagesForFilms() async {
    for (var element in filmsDictionary.entries) {
      String url = await getFilmsImage(element.value['keyword']);
      wordsImage[element.key] = url;
    }
  }

  Future<http.Response> fetchImageByKeyword(String keyWord) async {
    String apiKey = 'Ppw1eG0YzUaD-rRKTyLO3UXnrpLMK8Vi9qAFRQCoRmI';
    final uri = Uri.parse(
        'https://api.unsplash.com/search/photos/?client_id=$apiKey&query=${keyWord.toLowerCase()}&order_by=relevant&orientation=landscape');

    return http.get(uri);
  }

  Future<String> searchImage(String keyWord) async {
    final response = await fetchImageByKeyword(keyWord);

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return (result["results"][0]["urls"]["small"]);
    } else {
      return "https://via.placeholder.com/200x150/595ABA/595ABA";
    }
  }

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
                  height: getProportionateScreenHeight(20),
                ),
                Text(
                  "Подождите несколько секунд.\nПервый раз получаем данные с сервера ...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kMainTextColor,
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: kSecondBlue,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: getProportionateScreenHeight(50),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: getProportionateScreenWidth(20),
                      ),
                      child: Text(
                        "Начальный уровень:",
                        style: TextStyle(
                          color: kMainTextColor,
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(150),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.fromLTRB(
                                getProportionateScreenWidth(15),
                                getProportionateScreenHeight(0),
                                getProportionateScreenWidth(15),
                                getProportionateScreenHeight(0),
                              ),
                              physics: const BouncingScrollPhysics(),
                              itemCount: beginnerDictionary.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: getProportionateScreenWidth(10),
                                );
                              },
                              itemBuilder: (context, index) {
                                return categoryCard(
                                  "Beginer",
                                  index,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(50),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: getProportionateScreenWidth(20),
                      ),
                      child: Text(
                        "Средний уровень:",
                        style: TextStyle(
                          color: kMainTextColor,
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(150),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.fromLTRB(
                                getProportionateScreenWidth(15),
                                getProportionateScreenHeight(0),
                                getProportionateScreenWidth(15),
                                getProportionateScreenHeight(0),
                              ),
                              physics: const BouncingScrollPhysics(),
                              itemCount: intermediateDictionary.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: getProportionateScreenWidth(10),
                                );
                              },
                              itemBuilder: (context, index) {
                                return categoryCard(
                                  "Intermediate",
                                  index,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(50),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: getProportionateScreenWidth(20),
                      ),
                      child: Text(
                        "По сериалам и фильмам:",
                        style: TextStyle(
                          color: kMainTextColor,
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(150),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.fromLTRB(
                                getProportionateScreenWidth(15),
                                getProportionateScreenHeight(0),
                                getProportionateScreenWidth(15),
                                getProportionateScreenHeight(0),
                              ),
                              physics: const BouncingScrollPhysics(),
                              itemCount: filmsDictionary.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: getProportionateScreenWidth(10),
                                );
                              },
                              itemBuilder: (context, index) {
                                return categoryCard(
                                  "Films",
                                  index,
                                );
                              },
                            ),
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
      },
    );
  }

  Widget categoryCard(String typeList, int index) {
    {
      final String img = typeList == "Beginer"
          ? wordsImage[beginnerDictionary.keys.elementAt(index)].toString()
          : typeList == "Intermediate"
              ? wordsImage[intermediateDictionary.keys.elementAt(index)]
                  .toString()
              : typeList == "Films"
                  ? wordsImage[filmsDictionary.keys.elementAt(index)].toString()
                  : "https://via.placeholder.com/200x150/595ABA/595ABA";

      final String name = typeList == "Beginer"
          ? beginnerDictionary.keys.elementAt(index)
          : typeList == "Intermediate"
              ? intermediateDictionary.keys.elementAt(index)
              : typeList == "Films"
                  ? filmsDictionary.keys.elementAt(index)
                  : "https://via.placeholder.com/200x150/595ABA/595ABA";

      final List<dynamic> words = typeList == "Beginer"
          ? beginnerDictionary[name]['words']
          : typeList == "Intermediate"
              ? intermediateDictionary[name]['words']
              : typeList == "Films"
                  ? filmsDictionary[name]['words']
                  : null;

      return SizedBox(
        width: getProportionateScreenWidth(180),
        child: GestureDetector(
          onTap: () async {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                ) =>
                    WordsChoice(
                  wordsList: List<String>.from(words),
                  cardName: name,
                ),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
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
          child: Card(
            elevation: 4,
            shadowColor: kMainTextColor.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CachedNetworkImage(
                        width: getProportionateScreenWidth(180),
                        fit: BoxFit.cover,
                        imageUrl: img,
                        progressIndicatorBuilder: (
                          context,
                          url,
                          downloadProgress,
                        ) =>
                            LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(0),
                        getProportionateScreenHeight(10),
                        getProportionateScreenWidth(0),
                        getProportionateScreenHeight(10),
                      ),
                      child: Text(
                        name,
                        style: TextStyle(
                          color: kMainTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: getProportionateScreenWidth(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
