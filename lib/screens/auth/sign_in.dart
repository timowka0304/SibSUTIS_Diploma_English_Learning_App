import 'package:easy_peasy/components/auth/google_button.dart';
import 'package:easy_peasy/components/auth/auth_controller.dart';
import 'package:easy_peasy/components/others/shared_pref_user.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/routes.dart';
import 'package:easy_peasy/screens/auth/sign_up.dart';
import 'package:easy_peasy/screens/main/navigation_bar.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
  String _userEmailForgot = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController _textFieldController = TextEditingController();

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Введите почту'),
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
                child: const Text('Отмена'),
                onPressed: () {
                  setState(() {
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
                child: const Text('Ок'),
                onPressed: () async {
                  try {
                    await auth.sendPasswordResetEmail(
                        email: _textFieldController.text.trim());
                    setState(() {
                      Navigator.pop(context);
                    });
                    setState(() {
                      _userEmailForgot = "";
                    });
                    return showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Успешно"),
                        content: const Text(
                            "Письмо для сброса пароля отправлено на указанную почту"),
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
                  } on FirebaseAuthException catch (e) {
                    print(e.code);
                    print(e.message);
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
            .then((value) {
          if (value != null) {
            storeProfileUid(value!.uid);
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pushReplacementNamed(
                context, NavigationBarCustom.routeName);
          }
        });
      }
    }

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
          ),
          routes: routes,
          home: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: kMainPurple,
              body: SafeArea(
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: getProportionateScreenHeight(90),
                        ),
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            kLogoWhitePath,
                            height: getProportionateScreenHeight(135),
                            width: getProportionateScreenWidth(180),
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(120),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [Center(child: GoogleButton())],
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(20),
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              Text(
                                "или",
                                style: TextStyle(
                                    color: kWhite,
                                    fontSize: getProportionateScreenWidth(14)),
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
                                  primary: kWhite,
                                  fixedSize: Size(
                                      getProportionateScreenWidth(120),
                                      getProportionateScreenHeight(40)),
                                ),
                                onPressed: _trySubmitForm,
                                child: Text(
                                  'Войти',
                                  style: TextStyle(
                                    color: kMainTextColor,
                                    fontSize: getProportionateScreenWidth(14),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(5),
                              ),
                              InkWell(
                                onTap: () => _displayTextInputDialog(context),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Text(
                                  "Забыли пароль?",
                                  style: TextStyle(
                                    color: kWhite,
                                    fontWeight: FontWeight.w600,
                                    fontSize: getProportionateScreenWidth(12),
                                    // decoration: TextDecoration.underline,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: RichText(
                              text: TextSpan(
                                  text: "Еще нет аккаунта? ",
                                  style: TextStyle(
                                    color: kWhite,
                                    fontWeight: FontWeight.w400,
                                    fontSize: getProportionateScreenWidth(14),
                                  ),
                                  children: [
                                TextSpan(
                                  text: "Зарегистрируйся!",
                                  style: TextStyle(
                                    color: kWhite,
                                    fontWeight: FontWeight.w800,
                                    fontSize: getProportionateScreenWidth(14),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.pushNamed(
                                        context, SignUp.routeName),
                                )
                              ])),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(20),
                        ),
                      ],
                    ),
                  ),
                ),
              ))),
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
            fontSize: getProportionateScreenWidth(14)),
        onChanged: (value) => _password = value,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Введите пароль";
          }
          if (value.trim().length < 8) {
            return 'Минимальная длина пароля — 8 символов';
          }
          return null;
        },
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
                fontSize: getProportionateScreenWidth(12)),
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
            fontWeight: FontWeight.w200,
            fontSize: getProportionateScreenWidth(14)),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Введите адрес электронной почты";
          }
          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
            return 'Проверьте правильность введенных данных';
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail, color: kWhite),
          hintStyle: TextStyle(
              color: kWhite.withOpacity(0.5),
              fontWeight: FontWeight.w200,
              fontSize: getProportionateScreenWidth(14)),
          labelText: "Почта",
          labelStyle: TextStyle(
              color: kWhite,
              fontWeight: FontWeight.w200,
              fontSize: getProportionateScreenWidth(14)),
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
              fontSize: getProportionateScreenWidth(12)),
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
