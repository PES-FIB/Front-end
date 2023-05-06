import 'dart:math';

import 'package:flutter/material.dart';
import '../controllers/reviews_controller.dart';
import '../models/Review.dart';
import '../models/User.dart';
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
    Review review1 = Review(1000, "user1", widget.event.code, 3, "Molt divertit");
    Review review2 = Review(1001, "user2", widget.event.code, 4, "Molt divertit");
    Review review3 = Review(1002, "user3", widget.event.code, 2, "Molt divertit");

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
  final _reviewController = ReviewController(context);

  return Scaffold(
    body: Column(
      children: [
        //si el usuario no ha hecho review del evento, la puede crear, pero si ya la ha hecho, la puede editar o borrar
        if (fechaActual.isBefore(fechaEvento))
          MyReview(widget.event, _reviewController.takeMyReview(reviews,1000))
        else if (_reviewController.iMadeReviewForEvent(reviews, User.name)) 
          MyReview(widget.event, _reviewController.takeMyReview(reviews, User.id))
        else
          Column(
            children: [
              SizedBox(height: 15.0),
              Text("No compleixes els requisits per fer una valoració", style: TextStyle(fontSize: 15, color: Colors.red[900]), textAlign: TextAlign.center,),
            ],
          ),
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