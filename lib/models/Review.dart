import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Review {
  int userId;
  int idReview;
  String? username;
  String idActivity;
  String? title;
  int score;
  String contenido;
  
  Review(this.userId, this.idReview, this.username, this.idActivity, this.score, this.contenido, this.title);
  
  //mirar (no funciona correctament el primer cop)
  Widget buildRatingBar(bool ignoreGesture) {
    return RatingBar.builder(
      initialRating: score.toDouble(),
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemSize: 30,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      ignoreGestures: ignoreGesture,
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.redAccent,
      ),
      onRatingUpdate: (value) {
        score = value.toInt();
        print('score: $score');
        print('value: $value');
      },
      
    );
  }
}
