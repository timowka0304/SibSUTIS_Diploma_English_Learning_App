import 'package:easy_peasy/components/auth/email_field.dart';
import 'package:easy_peasy/components/auth/google_button.dart';
import 'package:easy_peasy/components/auth/password_field.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/routes.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatelessWidget {
  static String routeName = "/signin";

  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();
    SizeConfig().init(context);
    return MaterialApp(
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
                child: Column(
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
                        children: const [Center(child: GoogleButton())],
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    Expanded(
                      flex: 3,
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
                          const EmailField(),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          const PasswordField(),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: kWhite,
                              fixedSize: Size(getProportionateScreenWidth(120),
                                  getProportionateScreenHeight(40)),
                            ),
                            onPressed: () {
                              // print(_controller.text);
                            },
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
                            onTap: () {},
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Text(
                              "Восстановить пароль",
                              style: TextStyle(
                                color: kWhite,
                                fontWeight: FontWeight.w200,
                                fontSize: getProportionateScreenWidth(12),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Еще нет аккаунта? ",
                            style: TextStyle(
                              color: kWhite,
                              fontWeight: FontWeight.w400,
                              fontSize: getProportionateScreenWidth(14),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Text(
                              "Зарегистрируйся!",
                              style: TextStyle(
                                color: kWhite,
                                fontWeight: FontWeight.w400,
                                fontSize: getProportionateScreenWidth(14),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                  ],
                ),
              ),
            )));
  }
}
