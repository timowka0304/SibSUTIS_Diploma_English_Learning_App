import 'package:easy_peasy/components/others/dialogs.dart';
import 'package:easy_peasy/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final gooleSignIn = GoogleSignIn();

Future googleSignIn() async {
  GoogleSignInAccount? googleSignInAccount = await gooleSignIn.signIn();

  if (googleSignInAccount != null) {
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    await auth.signInWithCredential(credential);
    auth.currentUser;

    return Future.value(true);
  }
  return Future.value(false);
}

Future signIn(String email, String password, BuildContext context) async {
  try {
    UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    return Future.value(user);
  } on FirebaseException catch (e) {
    switch (e.code) {
      case "wrong-password":
        showErrDialog(context, "Неверный пароль", 2);
        break;
      case "user-not-found":
        showErrDialog(context, "Пользователь не найден", 2);
        break;
    }
    return Future.value(null);
  }
}

Future signUp(
    String email, String password, String name, BuildContext context) async {
  try {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = result.user;
    await user!.updateDisplayName(name);
    await user.updatePhotoURL(kDefaultAvatar);
    return Future.value(user);
  } on FirebaseException catch (e) {
    switch (e.code) {
      case "email-already-in-use":
        showErrDialog(context, "Этот адрес уже используется", 2);
        break;
    }
    return Future.value(null);
  }
}

Future signOutUser() async {
  if (auth.currentUser!.providerData[0].providerId == 'google.com') {
    await gooleSignIn.signOut();
  }
  await auth.signOut();
  return Future.value(true);
}
