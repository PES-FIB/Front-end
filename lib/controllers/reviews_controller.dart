import 'package:flutter/material.dart';
import 'dioController.dart';
import '../models/Review.dart';
import '../models/User.dart';
import '../models/Event.dart';

import '../views/review_screen.dart';

import '../APIs/reviewsApis.dart';

class ReviewController{
  final BuildContext context;
  ReviewController(this.context);

  //obte las reviews de un event
  Future<List<Review>> getReviews(String idActivity) async {
    final response = await dio.get(
      reviewApi.getReviewsUrl(idActivity)
    );
    final List<Review> reviews = [];
    for (var review in response.data) {
      reviews.add(Review(review['userId'], review['reviewId'], review['username'], review['idActivity'], review['score'], review['contenido']));
    }
    return reviews;
  }


  Future<bool> addReview(Review review) async {
    final response = await dio.post(
      reviewApi.getCreateReviewUrl(review.idActivity),
      data: {
        'rating': review.score,
        'comment': review.contenido,
      }
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteMyReview(Review review) async {
    final response = await dio.delete(
      reviewApi.getDeleteReviewUrl(review.idReview),
    );
    return response.statusCode == 200;
  }

  Future<bool> updateMyReview(Review review) async {
    final response = await dio.put(
      reviewApi.getUpdateReviewUrl(review.idReview),
      data: {
        'rating': review.score,
        'comment': review.contenido,
      }
    );
    return response.statusCode == 200;
  }
  Future<bool> reportReview(Review review) async {
     final response = await dio.post(
      reviewApi.getReportReviewUrl(review.idReview),
      data: {
        'type': 'report',
        'comment': 'The user ${User.name} has reported this review',
      },
     );  
     return response.statusCode == 200;
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
    return Review(-1, -1, "", "0", 1, "");
  }

  void toReviewsAgain(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReviewPage(event)),
    );
  }
}
