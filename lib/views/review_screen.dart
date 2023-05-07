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
    final _reviewController = ReviewController(context);
    _reviewController.getReviews(widget.event.code).then((value) => setState(() {
      reviews = value;
    }));
  }
  @override
  Widget build(BuildContext context) {
  DateTime fechaEvento = DateTime.parse(widget.event.finalDate);
  DateTime fechaActual = DateTime.now();
  final _reviewController = ReviewController(context);
  final eventName = widget.event.title;

  return Scaffold(
    body: Column(
      children: [
        //si el usuario no ha hecho review del evento, la puede crear, pero si ya la ha hecho, la puede editar o borrar
        if (fechaActual.isAfter(fechaEvento))
          MakeReview(context, widget.event)
        else if (_reviewController.iMadeReviewForEvent(reviews, User.name)) 
          MyReview(context, widget.event, _reviewController.takeMyReview(reviews, User.id))
        else
          Column(
            children: [
              SizedBox(height: 15.0),
              Text("No compleixes els requisits per fer una valoració", style: TextStyle(fontSize: 15, color: Colors.red[900]), textAlign: TextAlign.center,),
            ],
          ),
        SizedBox(height: 15.0),
        Text("Valoracions de l'event:\n$eventName", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
        SizedBox(height: 15.0),
        Expanded(
          child: 
            ReviewList(reviews, widget.event)
        )
      ],
    ),
  );
}


}