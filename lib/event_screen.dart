import 'package:flutter/material.dart';
import 'EventList.dart';


class Events extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ), 
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "C U L T U R I C A 'T",
          style: TextStyle(
            color:Colors.white,
            fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Text('hola'),
        
      ),
    );
  }
}