import 'dart:io';

import 'package:easy_peasy/components/others/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future updateImg(User user) async {
  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  final selectedImage = File(image!.path);

  final storage =
      FirebaseStorage.instanceFor(bucket: "gs://easy-peasy-25d2d.appspot.com");

  final storageRef = storage.ref().child("user/profile/${user.uid}");

  final uploadTask = storageRef.putFile(selectedImage);

  final comletedTask = await uploadTask;
  final String downloadUrl = await comletedTask.ref.getDownloadURL();

  return downloadUrl;
}

Future getDictionaryJSON() async {
  final storage =
      FirebaseStorage.instanceFor(bucket: 'gs://easy-peasy-25d2d.appspot.com');
  final storageRef = storage.ref().child('/dictionary/dictionary.json');
  final String downloadUrl = await storageRef.getDownloadURL();
  return downloadUrl;
}

Future getFilmsImage(String filmName) async {
  final storage =
      FirebaseStorage.instanceFor(bucket: 'gs://easy-peasy-25d2d.appspot.com');
  final storageRef = storage.ref().child('/dictionary/film_pics/$filmName.jpg');
  final String downloadUrl = await storageRef.getDownloadURL();
  return downloadUrl;
}
