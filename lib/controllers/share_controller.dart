// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';

class ShareController {  

  String ObtainMessage() {
    String url = "https://nattech.fib.upc.edu:40331/";
    return ("Check out this event! $url");
  }
  void ShareAction(String url) {
    Share.share(url);
  }

}