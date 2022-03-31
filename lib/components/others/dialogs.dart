import 'package:easy_peasy/constants.dart';
import 'package:flutter/material.dart';

showErrDialog(BuildContext context, String err, int flag) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Ошибка"),
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
          child: const Text("Ок"),
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
          child: const Text("Ок"),
        ),
      ],
    ),
  );
}
