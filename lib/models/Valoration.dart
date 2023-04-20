import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Valoracion {
  String username;
  int idActivity;
  double score;
  String contenido;
  
  Valoracion(this.username, this.idActivity, this.score, this.contenido);
  
  Widget buildRatingBar(bool ignoreGesture) {
    return RatingBar.builder(
      initialRating: score,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
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
