  import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_peasy/components/others/dialogs.dart';
import 'package:easy_peasy/components/others/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> playSound(
    String soundName,
    Map<String, String> headersTranslate,
    BuildContext context,
  ) async {
    LoadingIndicatorDialog().show(context);

    final urlSound = Uri.parse(
        'https://developers.lingvolive.com/api/v1/Sound?dictionaryName=LingvoUniversal (En-Ru)&fileName=$soundName');
    try {
      final resultSound = await jsonDecode((await http.get(
        urlSound,
        headers: headersTranslate,
      ))
          .body);

      final player = AudioPlayer();
      await player.playBytes(
        base64Decode(
          resultSound,
        ),
      );
    } catch (e) {
      showToastMsg('Ошибка: ' + e.hashCode.toString() + '\n' + e.toString());
    }

    LoadingIndicatorDialog().dismiss();
  }