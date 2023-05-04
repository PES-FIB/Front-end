// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import '../../controllers/share_controller.dart';
import '../../models/Event.dart';

Widget ShareButton(Event event,String url) {
  
  final ShareController sharecontroller = ShareController();

  if (url == '') {
    return Container();
  }
  else {
    return ElevatedButton(
      onPressed: () {
        String eUrl = event.url;
        String eTitle = event.title;
        final url = sharecontroller.ObtainMessage(eTitle, eUrl);
        sharecontroller.ShareAction(url); 
      },
      child: Row(
        children: [
          const SizedBox(width: 8, height: 30),
          const Icon(Icons.share, color: Colors.black),
          //espacio de 10px
          const SizedBox(width: 10),
          const Text(
            'Comparteix-lo!',
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}