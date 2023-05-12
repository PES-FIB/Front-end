// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import '../../models/User.dart';


Widget UserImage(){
  final userImage = User.photoUrl;
  if (userImage == '' || userImage == null) {
    return Image(image: AssetImage('assets/userImage.jpg'));
  } else {
    return Image.network(userImage, scale: 0.5,);
  }
} 