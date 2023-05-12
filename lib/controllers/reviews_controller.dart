import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../models/AppEvents.dart';
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
    print(idActivity);
    print(reviewApi.getReviewsUrl(idActivity));
    final response = await dio.get(
      reviewApi.getReviewsUrl(idActivity)
    );
    final List<Review> reviews = [];

    final List<dynamic> dataReviews = response.data['reviews'];
    for (var review in dataReviews) {
      //final userresp = await dio.get(userApis.getsingleUserUrl(user.toString()));
      reviews.add(Review(review['UserId'], review['id'], null , idActivity, review['score'], review['comment']));
    }
    print("agafades les reviews :)");
    return reviews;
  }

  Future<List<Review>> getMyReviews() async {
    final response = await dio.get(
      reviewApi.getUserReviewsUrl()
    );
    final List<Review> reviews = [];
    final myReviews = response.data['reviews'];
    for (var review in myReviews) {
      print(review);
      reviews.add(Review(User.id, review['id'], User.name, review["EventCode"], review['score'], review['comment']));
    }
    return reviews;
  }


  Future<int?> addReview(Review review) async {
    print(reviewApi.getCreateReviewUrl(review.idActivity));
    final response = await dio.post(
      reviewApi.getCreateReviewUrl(review.idActivity),
      data: {
        'rating': review.score,
        'comment': review.contenido,
      }
    );
    return response.statusCode;
  }

  Future<int?> deleteMyReview(Review review) async {
    print(reviewApi.getDeleteReviewUrl(review.idActivity));
    final response = await dio.delete(
      reviewApi.getDeleteReviewUrl(review.idActivity),
    );
    print(response.statusCode);
    print("fet delete");
    return response.statusCode;
  }

  Future<int?> updateMyReview(Review review) async {
    print(reviewApi.getUpdateReviewUrl(review.idActivity));
    final response = await dio.patch(
      reviewApi.getUpdateReviewUrl(review.idActivity),
      data: {
        'rating': review.score,
        'comment': review.contenido,
      }
    );
    return response.statusCode;
  }
  Future<int?> reportReview(Review review, String category, String comment) async {
     Response response;
     dio.options.validateStatus = (status) {
      // Permitir el código de estado 400 como respuesta exitosa
      return status! < 404;
  };
     try {
        final id = User.id;
        if (comment == '' || comment == null) comment = "L'usuari amb id: $id, no ha deixat cap comentari";
        final response = await dio.post(
          reviewApi.getReportReviewUrl(review.idReview),
          data: {
            'type': category,
            'comment': comment,
          },
        );  
      return response.statusCode;
      } catch (e) {
        print(e);
        return null;
     }
     
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
