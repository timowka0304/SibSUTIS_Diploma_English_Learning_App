import 'package:easy_peasy/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          )
        ],
      ),
    )));
  }
}
