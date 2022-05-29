import 'package:easy_peasy/components/auth/auth_controller.dart';
import 'package:easy_peasy/components/others/dialogs.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/screens/auth/sign_in.dart';
import 'package:easy_peasy/screens/main/main_screen.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignInState();
}

class _SignInState extends State<SignUp> {
  bool _isObscure = true;
  String _userName = '';
  String _userEmail = '';
  String _password = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    void _trySubmitForm() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
        try {
          await signUp(_userEmail.trim(), _password.trim(), _userName, context)
              .then(
            (value) {
              if (value != null) {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const MainScreenCheck(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
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
              }
            },
          );
        } catch (e) {
          showToastMsg(
              'Ошибка: ' + e.hashCode.toString() + '\n' + e.toString());
        }
      }
    }

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kMainPurple,
        body: SafeArea(
          child: Center(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: getProportionateScreenHeight(90),
                    ),
                    Image.asset(
                      kLogoWhitePath,
                      height: getProportionateScreenHeight(135),
                      width: getProportionateScreenWidth(180),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(60),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        children: [
                          emeilFiled(),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          passwordField(),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          nameFiled(),
                          SizedBox(
                            height: getProportionateScreenHeight(60),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                getProportionateScreenWidth(180),
                                getProportionateScreenHeight(50),
                              ),
                              maximumSize: Size(
                                getProportionateScreenWidth(230),
                                getProportionateScreenHeight(50),
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              primary: kWhite,
                            ),
                            onPressed: _trySubmitForm,
                            child: Text(
                              'Зарегистрироваться',
                              style: TextStyle(
                                color: kMainTextColor,
                                fontSize: getProportionateScreenWidth(16),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(50),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                getProportionateScreenWidth(80),
                                getProportionateScreenHeight(40),
                              ),
                              maximumSize: Size(
                                getProportionateScreenWidth(100),
                                getProportionateScreenHeight(40),
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              primary: kWhite,
                            ),
                            onPressed: () => {
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SignIn(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
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
                              ),
                            },
                            child: Text(
                              'Назад',
                              style: TextStyle(
                                color: kMainTextColor,
                                fontSize: getProportionateScreenWidth(16),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(50),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container passwordField() {
    return Container(
      width: getProportionateScreenWidth(280),
      decoration: const BoxDecoration(
        color: kMainPurple,
      ),
      child: TextFormField(
        obscureText: _isObscure,
        style: TextStyle(
          color: kWhite,
          fontWeight: FontWeight.w300,
          fontSize: getProportionateScreenWidth(16),
        ),
        onChanged: (value) => _password = value,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Введите пароль";
          }
          if (value.trim().length < 8) {
            return 'Минимальная длина 8';
          }
          return null;
        },
        decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.lock,
              color: kWhite,
            ),
            hintStyle: TextStyle(
              color: kWhite.withOpacity(0.5),
              fontWeight: FontWeight.w300,
              fontSize: getProportionateScreenWidth(16),
            ),
            labelText: "Пароль",
            labelStyle: TextStyle(
              color: kWhite,
              fontWeight: FontWeight.w300,
              fontSize: getProportionateScreenWidth(16),
            ),
            hintText: 'qwerty123',
            isDense: true,
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: kMainPink,
                width: 1.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: kMainPink,
                width: 1.0,
              ),
            ),
            errorStyle: TextStyle(
                color: kWhite,
                fontWeight: FontWeight.w300,
                fontSize: getProportionateScreenWidth(14)),
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

  Container emeilFiled() {
    return Container(
      width: getProportionateScreenWidth(280),
      decoration: const BoxDecoration(
        color: kMainPurple,
      ),
      child: TextFormField(
        onChanged: (value) => _userEmail = value,
        style: TextStyle(
          color: kWhite,
          fontWeight: FontWeight.w300,
          fontSize: getProportionateScreenWidth(16),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Введите почту";
          }
          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
            return 'Проверьте формат';
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.mail,
            color: kWhite,
          ),
          hintStyle: TextStyle(
            color: kWhite.withOpacity(0.5),
            fontWeight: FontWeight.w300,
            fontSize: getProportionateScreenWidth(16),
          ),
          labelText: "Почта",
          labelStyle: TextStyle(
            color: kWhite,
            fontWeight: FontWeight.w300,
            fontSize: getProportionateScreenWidth(16),
          ),
          hintText: 'example@gmail.com',
          isDense: true,
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: kMainPink,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: kMainPink,
              width: 1.0,
            ),
          ),
          errorStyle: TextStyle(
            color: kWhite,
            fontWeight: FontWeight.w300,
            fontSize: getProportionateScreenWidth(14),
          ),
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
        ),
      ),
    );
  }

  Container nameFiled() {
    return Container(
      width: getProportionateScreenWidth(280),
      decoration: const BoxDecoration(
        color: kMainPurple,
      ),
      child: TextFormField(
        onChanged: (value) => _userName = value,
        style: TextStyle(
          color: kWhite,
          fontWeight: FontWeight.w300,
          fontSize: getProportionateScreenWidth(16),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Введите имя";
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.person,
            color: kWhite,
          ),
          hintStyle: TextStyle(
            color: kWhite.withOpacity(0.5),
            fontWeight: FontWeight.w300,
            fontSize: getProportionateScreenWidth(16),
          ),
          labelText: "Имя",
          labelStyle: TextStyle(
            color: kWhite,
            fontWeight: FontWeight.w300,
            fontSize: getProportionateScreenWidth(16),
          ),
          hintText: 'Иван1982',
          isDense: true,
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: kMainPink,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: kMainPink,
              width: 1.0,
            ),
          ),
          errorStyle: TextStyle(
            color: kWhite,
            fontWeight: FontWeight.w300,
            fontSize: getProportionateScreenWidth(14),
          ),
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
        ),
      ),
    );
  }
}
