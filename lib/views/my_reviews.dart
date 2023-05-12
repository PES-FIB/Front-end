import 'dart:math';

import 'package:flutter/material.dart';
import '../controllers/reviews_controller.dart';
import '../models/Review.dart';
import '../models/User.dart';
import 'styles/review_styles.dart';
import '../models/Event.dart';

class MyReview extends StatefulWidget {

  @override
  _MyReviewState createState() => _MyReviewState();
}

class _MyReviewState extends State<MyReview> {
  List<Review> reviews = [];
  String username = User.name;

  @override
  void initState() {
    super.initState();
    final _reviewController = ReviewController(context);
    _reviewController.getMyReviews().then((value) => setState(() {
      reviews = value;
    })
    );
    /*
    final review1 = Review(User.id, 1, User.name, null, 5, "Molt divertit!");
    final review2 = Review(User.id, 2, User.name, null, 5, "Molt divertit!");
    final review3 = Review(User.id, 3, User.name, null, 5, "Molt divertit!");
    final review4 = Review(User.id, 4, User.name, null, 5, "Molt divertit!");
    final review5 = Review(User.id, 5, User.name, null, 5, "Molt divertit!");

    reviews = [review1, review2, review3, review4, review5];
    */
  }
  @override
  Widget build(BuildContext context) {
  final _reviewController = ReviewController(context);

  return Scaffold(
    body: Column(
      children: [
        //si el usuario no ha hecho review del evento, la puede crear, pero si ya la ha hecho, la puede editar o borrar
        SizedBox(height: 15.0),
        Text("Aquestes son les meves valoracións", style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
        SizedBox(height: 15.0),
        Expanded(
          child: 
            MyReviewsList(context, reviews)
        )
      ],
    ),
  );
}


}