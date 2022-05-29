import 'package:easy_peasy/components/auth/google_button.dart';
import 'package:easy_peasy/components/auth/auth_controller.dart';
import 'package:easy_peasy/components/others/dialogs.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/screens/auth/sign_up.dart';
import 'package:easy_peasy/screens/main/main_screen.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  static String routeName = "/signin";

  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isObscure = true;
  String _userEmail = '';
  String _password = '';
  // ignore: unused_field
  late String _userEmailForgot;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textFieldController = TextEditingController();

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Введите почту',
            style: TextStyle(
              fontSize: getProportionateScreenWidth(20),
            ),
          ),
          content: TextFormField(
            onChanged: (value) {
              setState(() {
                _userEmailForgot = value.trim();
              });
            },
            controller: _textFieldController,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return kMainPurple;
                  },
                ),
              ),
              child: Text(
                'Отмена',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(16),
                ),
              ),
              onPressed: () {
                setState(() {
                  _textFieldController.text = "";
                  _userEmailForgot = "";
                  Navigator.pop(context);
                });
              },
            ),
            ElevatedButton(
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                return kMainPink;
              })),
              child: Text(
                'Ок',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(16),
                ),
              ),
              onPressed: () async {
                try {
                  await auth.sendPasswordResetEmail(
                    email: _textFieldController.text.trim(),
                  );
                  Navigator.pop(context);
                  setState(() {
                    _textFieldController.text = "";
                    _userEmailForgot = "";
                  });
                  return showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        "Успешно",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(16),
                        ),
                      ),
                      content: Text(
                        "Письмо для сброса пароля отправлено на указанную почту",
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
                          style: ButtonStyle(backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            return kMainPurple;
                          })),
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
                } on FirebaseAuthException catch (e) {
                  switch (e.code) {
                    case "unknown":
                      showErrDialog(context, "Пустое поле", 1);
                      break;
                    case "invalid-email":
                      showErrDialog(context, "Неверный формат", 1);
                      break;
                    case "user-not-found":
                      showErrDialog(context, "Пользователь не найден", 1);
                      break;
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
        await signIn(_userEmail.trim(), _password.trim(), context)
            .then((value) async {
          if (value != null) {
            // await storeProfileUid(value!.uid);
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
            Navigator.of(context, rootNavigator: true).pop();
          }
        });
      }
    }

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          extendBody: true,
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
                        height: getProportionateScreenHeight(50),
                      ),
                      Image.asset(
                        kLogoWhitePath,
                        height: getProportionateScreenHeight(135),
                        width: getProportionateScreenWidth(180),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(100),
                      ),
                      Column(
                        children: const [
                          Center(
                            child: GoogleButton(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(30),
                      ),
                      Flexible(
                        child: Column(
                          children: [
                            Text(
                              "или",
                              style: TextStyle(
                                color: kWhite,
                                fontSize: getProportionateScreenWidth(16),
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            emeilFiled(),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            passwordField(),
                            SizedBox(
                              height: getProportionateScreenHeight(30),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                primary: kWhite,
                              ),
                              onPressed: _trySubmitForm,
                              child: Text(
                                'Войти',
                                style: TextStyle(
                                  color: kMainTextColor,
                                  fontSize: getProportionateScreenWidth(16),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(60),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () => _displayTextInputDialog(context),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Text(
                              "Забыли пароль?",
                              style: TextStyle(
                                color: kWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: getProportionateScreenWidth(16),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          RichText(
                              text: TextSpan(
                                  text: "Еще нет аккаунта? ",
                                  style: TextStyle(
                                    color: kWhite,
                                    fontWeight: FontWeight.w400,
                                    fontSize: getProportionateScreenWidth(16),
                                  ),
                                  children: [
                                TextSpan(
                                  text: "Зарегистрируйся!",
                                  style: TextStyle(
                                    color: kWhite,
                                    fontWeight: FontWeight.w800,
                                    fontSize: getProportionateScreenWidth(16),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () =>
                                        // Navigator.pushNamed(
                                        //     context, SignUp.routeName),
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                const SignUp(),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
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
                                )
                              ])),
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
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
          fontWeight: FontWeight.w200,
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
}
