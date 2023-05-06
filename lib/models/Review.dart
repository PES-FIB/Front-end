import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Review {
  int userId;
  String username;
  String idActivity;
  double score;
  String contenido;
  
  Review(this.userId, this.username, this.idActivity, this.score, this.contenido);
  
  Widget buildRatingBar(bool ignoreGesture) {
    return RatingBar.builder(
      initialRating: score,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      ignoreGestures: ignoreGesture,
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (value) {
        score = value;
      },
    );
  }
}
