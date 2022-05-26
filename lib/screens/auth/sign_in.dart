import 'package:easy_peasy/components/auth/google_button.dart';
import 'package:easy_peasy/components/auth/auth_controller.dart';
import 'package:easy_peasy/components/others/dialogs.dart';
import 'package:easy_peasy/components/others/shared_pref.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/screens/auth/sign_up.dart';
import 'package:easy_peasy/screens/main/main_screen.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                fontSize: 28.sp,
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
                style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                  return kMainPurple;
                })),
                child: Text(
                  'Отмена',
                  style: TextStyle(
                    fontSize: 18.sp,
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
                    fontSize: 18.sp,
                  ),
                ),
                onPressed: () async {
                  try {
                    await auth.sendPasswordResetEmail(
                        email: _textFieldController.text.trim());
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
                            fontSize: 18.sp,
                          ),
                        ),
                        content: Text(
                          "Письмо для сброса пароля отправлено на указанную почту",
                          style: TextStyle(
                            fontSize: 18.sp,
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
                                fontSize: 18.sp,
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
        });
  }

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
            });
        await signIn(_userEmail.trim(), _password.trim(), context)
            .then((value) async {
          if (value != null) {
            // await storeProfileUid(value!.uid);
            Navigator.pushReplacementNamed(context, MainScreenCheck.routeName);
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
                        height: ScreenUtil().setHeight(50),
                      ),
                      Image.asset(
                        kLogoWhitePath,
                        height: ScreenUtil().setHeight(135),
                        width: ScreenUtil().setWidth(180),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(100),
                      ),
                      Column(
                        children: [Center(child: GoogleButton())],
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(30),
                      ),
                      Flexible(
                        child: Column(
                          children: [
                            Text(
                              "или",
                              style: TextStyle(
                                color: kWhite,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            emeilFiled(),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            passwordField(),
                            SizedBox(
                              height: ScreenUtil().setHeight(30),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                // minimumSize: Size(
                                //     getProportionateScreenWidth(120),
                                //     getProportionateScreenHeight(50)),
                                // maximumSize: Size(
                                //     getProportionateScreenWidth(120),
                                //     getProportionateScreenHeight(50)),
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
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
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
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(40),
                          ),
                          RichText(
                              text: TextSpan(
                                  text: "Еще нет аккаунта? ",
                                  style: TextStyle(
                                    color: kWhite,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                  ),
                                  children: [
                                TextSpan(
                                  text: "Зарегистрируйся!",
                                  style: TextStyle(
                                    color: kWhite,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16.sp,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.pushNamed(
                                        context, SignUp.routeName),
                                )
                              ])),
                          SizedBox(
                            height: ScreenUtil().setHeight(30),
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
      width: ScreenUtil().setWidth(280),
      decoration: const BoxDecoration(
        color: kMainPurple,
      ),
      child: TextFormField(
        obscureText: _isObscure,
        style: TextStyle(
          color: kWhite,
          fontWeight: FontWeight.w200,
          fontSize: 16.sp,
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
            prefixIcon: const Icon(Icons.lock, color: kWhite),
            hintStyle: TextStyle(
              color: kWhite.withOpacity(0.5),
              fontWeight: FontWeight.w200,
              fontSize: 16.sp,
            ),
            labelText: "Пароль",
            labelStyle: TextStyle(
              color: kWhite,
              fontWeight: FontWeight.w200,
              fontSize: 16.sp,
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
              fontWeight: FontWeight.w200,
              fontSize: 14.sp,
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
      width: ScreenUtil().setWidth(280),
      decoration: const BoxDecoration(
        color: kMainPurple,
      ),
      child: TextFormField(
        onChanged: (value) => _userEmail = value,
        style: TextStyle(
          color: kWhite,
          fontWeight: FontWeight.w200,
          fontSize: 16.sp,
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
          prefixIcon: const Icon(Icons.mail, color: kWhite),
          hintStyle: TextStyle(
            color: kWhite.withOpacity(0.5),
            fontWeight: FontWeight.w200,
            fontSize: 16.sp,
          ),
          labelText: "Почта",
          labelStyle: TextStyle(
            color: kWhite,
            fontWeight: FontWeight.w200,
            fontSize: 16.sp,
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
            fontWeight: FontWeight.w200,
            fontSize: 14.sp,
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
