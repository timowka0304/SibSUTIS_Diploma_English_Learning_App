import 'package:easy_peasy/routes.dart';
import 'package:easy_peasy/screens/auth/sign_in.dart';
import 'package:easy_peasy/screens/main/navigation_bar.dart';
import 'package:easy_peasy/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/home";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      ),
      routes: routes,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return const HomePageLogged();
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Что-то пошло не так! Попробуйте снова!'),
              );
            } else {
              return SignIn();
            }
          }),
    );
  }
}

class HomePageLogged extends StatelessWidget {
  const HomePageLogged({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(user.photoURL!),
          ),
          const SizedBox(
            height: 50,
          ),
          Text(
            user.displayName!,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          )
        ],
      ),
    )));
  }
}
