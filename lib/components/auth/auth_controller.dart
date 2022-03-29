import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/screens/main/home_page.dart';
import 'package:easy_peasy/screens/main/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final gooleSignIn = GoogleSignIn();

showErrDialog(BuildContext context, String err) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Ошибка"),
      content: Text(err),
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
          child: Text("Ок"),
        ),
      ],
    ),
  );
}

// many unhandled google error exist
// will push them soon
Future<bool> googleSignIn() async {
  GoogleSignInAccount? googleSignInAccount = await gooleSignIn.signIn();

  if (googleSignInAccount != null) {
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = await auth.signInWithCredential(credential);

    User? user = await auth.currentUser;
    print(user!.uid);

    return Future.value(true);
  }
  return Future.value(false);
}

// instead of returning true or false
// returning user to directly access UserID
Future<User> signIn(String email, String password, BuildContext context) async {
  try {
    UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    // return Future.value(true);
    return Future.value(user);
  } catch (e) {
    // print(e.toString());
    // print(e.hashCode);
    switch (e.hashCode) {
      case 185768934:
        showErrDialog(context, "Неверный пароль");
        break;
      case 505284406:
        showErrDialog(context, "Пользователь не найден");
        break;
    }
    // since we are not actually continuing after displaying errors
    // the false value will not be returned
    // hence we don't have to check the valur returned in from the signin function
    // whenever we call it anywhere
    return Future.value(null);
  }
}

// change to Future<FirebaseUser> for returning a user
Future<User> signUp(
    String email, String password, String name, BuildContext context) async {
  try {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: email);
    User? user = result.user;
    await user!.updateDisplayName(name);
    await user.updatePhotoURL(kDefaultAvatar);
    return Future.value(user);
    // return Future.value(true);
  } catch (error) {
    // print(error.toString());
    // print(error.hashCode);
    switch (error.hashCode) {
      case 34618382:
        showErrDialog(context, "Этот адрес уже используется");
        break;
    }
    return Future.value(null);
  }
}

Future<bool> signOutUser() async {
  if (auth.currentUser!.providerData[0].providerId == 'google.com') {
    await gooleSignIn.disconnect();
  }
  await auth.signOut();
  return Future.value(true);
}
