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
    })
    );
    
    /*
    final review1 = Review(1000, 1, 'user1', widget.event.code, 5, "Molt divertit!");
    final review2 = Review(1001, 2, 'user2', widget.event.code, 5, "Molt divertit!");
    final review3 = Review(1002, 3, 'user3', widget.event.code, 5, "Molt divertit!");

    reviews = [review1, review2, review3];
    */
  }
  @override
  Widget build(BuildContext context) {
  DateTime fechaEvento = DateTime.parse(widget.event.finalDate);
  DateTime fechaActual = DateTime.now();
  final _reviewController = ReviewController(context);
  final eventName = widget.event.title;

  return Scaffold(
    body: Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20,),
                onPressed: () => Navigator.pop(context, widget.event), //retuning to homePage and updating current event if necessary. 
              ),
            ),
            //si el usuario no ha hecho review del evento, la puede crear, pero si ya la ha hecho, la puede editar o borrar
            if (_reviewController.iMadeReviewForEvent(reviews, User.name)) 
              MyReview(context, widget.event, _reviewController.takeMyReview(reviews, User.id))
            else if (fechaActual.isAfter(fechaEvento))
              MakeReview(context, widget.event)
            else
              Column(
                children: [
                  SizedBox(height: 15.0),
                  Text("L'event encara no ha començat, per tant, encara no es pot valorar", style: TextStyle(fontSize: 15, color: Colors.redAccent, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                ],
              ),
            SizedBox(height: 15.0),
            Text("Valoracions de l'event:\n$eventName", style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
            SizedBox(height: 15.0),
            if (reviews.length == 0)
              Text("Encara no hi ha cap valoració", style: TextStyle(fontSize: 15, color: Colors.redAccent, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
            else 
              Expanded(
                child: 
                  ReviewList(reviews, widget.event)
              ),
          ],
        ),
      ),
    ),
  );
}


}