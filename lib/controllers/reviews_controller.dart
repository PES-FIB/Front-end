import 'package:flutter/material.dart';
import 'dioController.dart';
import '../models/Review.dart';
import '../models/User.dart';

class ReviewController{
  final BuildContext context;
  ReviewController(this.context);

  Future<List<Review>> getReviews(int idActivity) async {
    final response = await dio.get('/reviews/$idActivity');
    final List<Review> reviews = [];
    for (var review in response.data) {
      reviews.add(Review(review['userId'], review['username'], review['idActivity'], review['score'], review['contenido']));
    }
    return reviews;
  }

  Future<bool> addReview(Review review) async {
    final response = await dio.post('/reviews', data: review);
    return response.statusCode == 200;
  }

  Future<void> roportReview(Review review, User reporter) async {
     
  }

  bool iMadeReviewForEvent(List<Review> reviews, String username) {
    for (var review in reviews) {
      if (review.username == username) {
        return true;
      }
    }
    return false;
  }

  Review takeMyReview(List<Review> reviews, int userId) {
    for (var review in reviews) {
      if (review.userId == userId) {
        return review;
      }
    }
    return Review(-1,"", "0", 1, "");
  }
}
