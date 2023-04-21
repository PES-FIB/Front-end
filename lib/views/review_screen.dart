import 'dart:math';

import 'package:flutter/material.dart';
import '../controllers/valoracions_controller.dart';
import '../models/Review.dart';
import 'styles/review_styles.dart';
import '../models/Event.dart';

class ReviewPage extends StatefulWidget {
  final Event event;
  ReviewPage(this.event);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<Review> reviews = [];

  @override
  void initState() {
    super.initState();
    Review review1 = Review("user1", widget.event.code, 3, "Molt divertit");
    Review review2 = Review("user2", widget.event.code, 4, "Molt divertit");
    Review review3 = Review("user3", widget.event.code, 2, "Molt divertit");

    reviews = [
      review1,
      review2,
      review3,
    ];
  }
  @override
  Widget build(BuildContext context) {
  DateTime fechaEvento = DateTime.parse(widget.event.finalDate);
  DateTime fechaActual = DateTime.now();

  return Scaffold(
    body: Column(
      children: [
        if (fechaActual.isBefore(fechaEvento))
          MakeReview(widget.event),
        SizedBox(height: 15.0),
        Text("Valoracions dels usuaris", style: TextStyle(fontSize: 20),),
        SizedBox(height: 15.0),
        Expanded(
          child: ReviewList(reviews, widget.event)
        )
      ],
    ),
  );
}


}