import 'package:flutter/material.dart';

SnackBar customSnackbar(BuildContext context, String message) {
  return SnackBar(
    backgroundColor: Colors.white,
    content: Text(
      message,
      style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 177, 12, 0)),
    ),
  );
}

