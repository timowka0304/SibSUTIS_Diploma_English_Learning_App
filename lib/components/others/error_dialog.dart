import 'package:easy_peasy/constants.dart';
import 'package:flutter/material.dart';

showErrDialog(BuildContext context, String err, int flag) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Ошибка"),
      content: Text(err),
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
          child: Text("Ок"),
        ),
      ],
    ),
  );
}
