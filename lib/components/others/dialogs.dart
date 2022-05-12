import 'package:easy_peasy/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

showErrDialog(BuildContext context, String err, int flag) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        "Ошибка",
        style: TextStyle(
          fontSize: 28.sp,
        ),
      ),
      content: Text(err),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            flag == 2 ? Navigator.of(context).pop() : null;
          },
          style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
            return kMainPurple;
          })),
          child: Text(
            "Ок",
            style: TextStyle(
              fontSize: 18.sp,
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
      title: Text(title),
      content: Text(text),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
            return kMainPurple;
          })),
          child: Text(
            "Ок",
            style: TextStyle(
              fontSize: 18.sp,
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
      title: Text('Справка'),
      content: Text(
          'Перечлючатель слева от значчка справки включает и выключает подсказку.'),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
            return kMainPurple;
          })),
          child: Text(
            "Ок",
            style: TextStyle(
              fontSize: 18.sp,
            ),
          ),
        ),
      ],
    ),
  );
}
