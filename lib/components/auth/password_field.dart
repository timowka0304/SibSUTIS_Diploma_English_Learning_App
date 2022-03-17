import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({Key? key}) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscure = true;
  var _usernameController = TextEditingController();
  late String _password;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getProportionateScreenWidth(280),
      decoration: const BoxDecoration(
        color: kMainPurple,
      ),
      child: TextField(
        controller: _usernameController,
        obscureText: _isObscure,
        style: TextStyle(
            color: kWhite,
            fontWeight: FontWeight.w200,
            fontSize: getProportionateScreenWidth(14)),
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock, color: kWhite),
            hintStyle: TextStyle(
                color: kWhite.withOpacity(0.5),
                fontWeight: FontWeight.w200,
                fontSize: getProportionateScreenWidth(14)),
            labelText: "Пароль",
            labelStyle: TextStyle(
                color: kWhite,
                fontWeight: FontWeight.w200,
                fontSize: getProportionateScreenWidth(14)),
            hintText: 'qwerty123',
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: kWhite,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: kWhite,
                width: 1.0,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility : Icons.visibility_off,
                color: kWhite.withOpacity(0.5),
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            )),
      ),
    );
  }
}
