import 'package:flutter/material.dart';
import 'dioController.dart';
import '../models/Review.dart';
import '../models/User.dart';
import '../models/Event.dart';

import '../views/review_screen.dart';
import '../views/my_reviews.dart';

import '../APIs/reviewsApis.dart';
import '../APIs/userApis.dart';



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
      final userresp = await dio.get(userApis.getsingleUserUrl(response.data['userId']));
      reviews.add(Review(userresp.data['user']['id'], review['review']['id'], userresp.data['user']['name'], idActivity, review['review']['score'], review['review']['comment']));
    }
    return reviews;
  }

  Future<List<Review>> getMyReviews() async {
    final response = await dio.get(
      reviewApi.getUserReviewsUrl()
    );
    final List<Review> reviews = [];
    for (var review in response.data) {
      reviews.add(Review(User.id, review['review']['id'], User.name, null, review['review']['score'], review['review']['comment']));
    }
    return reviews;
  }


  Future<bool> addReview(Review review) async {
    final response = await dio.post(
      reviewApi.getCreateReviewUrl(review.idActivity as String),
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
  Future<bool> reportReview(Review review, String category, String comment) async {
     final id = User.id;
      if (comment == '' || comment == null) comment = "L'usuari amb id $id no ha deixat cap comentari";
     final response = await dio.post(
      reviewApi.getReportReviewUrl(review.idReview),
      data: {
        'type': category,
        'comment': comment,
      },
     );  
     return response.statusCode == 200;
  }

  bool iMadeReviewForEvent(List<Review> reviews, String username) {
    for (var review in reviews) {
      if (review.userId == User.id) {
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
    print('recarrga de les valoracions');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReviewPage(event)),
    );
  }
  void toUserReviews() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyReview()),
    );
  }
}
