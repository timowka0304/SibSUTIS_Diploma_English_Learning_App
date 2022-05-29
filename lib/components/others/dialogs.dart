import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showErrDialog(BuildContext context, String err, int flag) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        "Ошибка",
        style: TextStyle(
          fontSize: getProportionateScreenWidth(20),
        ),
      ),
      content: Text(
        err,
        style: TextStyle(
          fontSize: getProportionateScreenWidth(16),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            flag == 2 ? Navigator.of(context).pop() : null;
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return kMainPurple;
              },
            ),
          ),
          child: Text(
            "Ок",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(16),
            ),
          ),
        ),
      ],
    ),
  );
}

showAchivementsDialog(BuildContext context, String title, String text) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          fontSize: getProportionateScreenWidth(20),
        ),
      ),
      content: Text(text),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return kMainPurple;
              },
            ),
          ),
          child: Text(
            "Ок",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(16),
            ),
          ),
        ),
      ],
    ),
  );
}

showInfoDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Справка',
        style: TextStyle(
          fontSize: getProportionateScreenWidth(20),
        ),
      ),
      content: Text(
        'Переключатель включает и отключает подсказку при перетаскивании карты.\n\nПопробуй!',
        style: TextStyle(
          fontSize: getProportionateScreenWidth(16),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return kMainPurple;
              },
            ),
          ),
          child: Text(
            "Ок",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(16),
            ),
          ),
        ),
      ],
    ),
  );
}

showToastMsg(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: kMainPink,
    textColor: kWhite,
    fontSize: getProportionateScreenWidth(16),
  );
}
