// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:prova_login/controllers/eventsController.dart';
import '../../models/Event.dart';

Widget ShareButton(Event event,String url) {


  if (url == '') {
    return Container();
  }
  else {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent), 
        elevation: MaterialStateProperty.all<double>(0),
      ),
      onPressed: () {
        String eUrl = event.url;
        String eTitle = event.title;
        final url = EventsController.ObtainMessage(eTitle, eUrl);
        EventsController.ShareAction(url); 
      },
      child: Row(
        children: [
          const SizedBox(width: 8, height: 30),
          const Icon(Icons.share, color: Colors.white),
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