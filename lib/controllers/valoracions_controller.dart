import 'package:flutter/material.dart';
import 'dioController.dart';
import '../models/Review.dart';


class ReviewController{
  final BuildContext context;
  ReviewController(this.context);

  Future<List<Review>> getReviews(int idActivity) async {
    final response = await dio.get('/reviews/$idActivity');
    final List<Review> reviews = [];
    for (var review in response.data) {
      reviews.add(Review(review['username'], review['idActivity'], review['score'], review['contenido']));
    }
    return reviews;
  }

  Future<bool> addReview(Review review) async {
    final response = await dio.post('/reviews', data: review);
    return response.statusCode == 200;
  }



  
}
