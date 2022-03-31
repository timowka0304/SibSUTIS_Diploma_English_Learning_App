import 'package:easy_peasy/components/others/error_dialog.dart';
import 'package:easy_peasy/constants.dart';
import 'package:easy_peasy/screens/main/home_page.dart';
import 'package:easy_peasy/screens/main/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final gooleSignIn = GoogleSignIn();

// showErrDialog(BuildContext context, String err) {
//   return showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text("Ошибка"),
//       content: Text(err),
//       actions: <Widget>[
//         ElevatedButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//             Navigator.of(context).pop();
//           },
//           style: ButtonStyle(backgroundColor:
//               MaterialStateProperty.resolveWith<Color>(
//                   (Set<MaterialState> states) {
//             return kMainPurple;
//           })),
//           child: Text("Ок"),
//         ),
//       ],
//     ),
//   );
// }

// many unhandled google error exist
// will push them soon
Future googleSignIn() async {
  GoogleSignInAccount? googleSignInAccount = await gooleSignIn.signIn();

  if (googleSignInAccount != null) {
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = await auth.signInWithCredential(credential);
    User? user = await auth.currentUser;

    return Future.value(true);
  }
  return Future.value(false);
}

// instead of returning true or false
// returning user to directly access UserID
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

// change to Future<FirebaseUser> for returning a user
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
    await gooleSignIn.disconnect();
  }
  await auth.signOut();
  return Future.value(true);
}
