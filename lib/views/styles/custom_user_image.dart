// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import '../../models/User.dart';


Widget UserImage(){
  final userImage = User.photoUrl;
  if (userImage == '') {
    print('userImage is empty');
    return Image(image: AssetImage('assets/userImage.jpg'));
  } else {
    print("User has Image");
    return Image.network(userImage);
  }
} 