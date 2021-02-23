import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Constants {
  static final Constants _singleton = new Constants._internal();
  
  factory Constants() {
    return _singleton;
  }

  Constants._internal();

  static void showDialog(String message) {
    // Get.di
    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        title: Text('Signal Meme Stickers'),
        content: Text(message),
        actions: [
          FlatButton(
            onPressed: () {
              Get.back();
            },
            child: Text('OK')
          )
        ],
      )
    );
  }
}
