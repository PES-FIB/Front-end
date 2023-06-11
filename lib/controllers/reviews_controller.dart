import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart';
import '../models/AppEvents.dart';
import '../models/Review.dart';
import '../models/User.dart';
import '../models/Event.dart';

import '../views/review_screen.dart';
import '../views/my_reviews.dart';

import '../APIs/reviewsApis.dart';
import '../APIs/userApis.dart';
import '../APIs/reportsApis.dart';


class ReviewController{
  final BuildContext context;
  ReviewController(this.context);

  //obte las reviews de un event
  Future<List<Review>> getReviews(String idActivity) async {
    final response = await dio.get(
      reviewApi.getReviewsUrl(idActivity)
    );
    final List<Review> reviews = [];

    final List<dynamic> dataReviews = response.data['reviews'];
    for (var review in dataReviews) {
      String? username;
      //final userresp = await dio.get(userApis.getsingleUserUrl(user.toString()));
      
      
      if (User.id != review['UserId']) {
        final name = review['User']['name'];
        final email = review['User']['email'];
        username = name + "(" + email + ")";
      } else {
        username = "mí";
      }
      reviews.add(Review(review['UserId'], review['id'], username , idActivity, review['score'], review['comment'], null));
    }
    return reviews;
  }

  Future<List<Review>> getMyReviews() async {
    final response = await dio.get(
      reviewApi.getUserReviewsUrl()
    );
    final List<Review> reviews = [];
    final myReviews = response.data['reviews'];
    for (var review in myReviews) {
      //busca el nombre del evento
      Event? event = AppEvents.eventsList.firstWhereOrNull((event) => event.code == review["EventCode"]);
      if (event != null) {
        reviews.add(Review(User.id, review['id'], User.name, review["EventCode"] , review['score'], review['comment'], event.title));
      }
    }
    return reviews;
  }


  Future<int?> addReview(Review review) async {
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
    final response = await dio.delete(
      reviewApi.getDeleteReviewUrl(review.idActivity),
    );
    return response.statusCode;
  }

  Future<int?> updateMyReview(Review review) async {
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
      return status! < 501;
    };
     try {
        final id = User.id;
        switch (category) {
          case 'Assatjament':
            category = 'harassment';
            break;
          case 'Spam':
            category = 'spam';
            break;
          case 'Contingut inadequat':
            category = 'inappropriate content';
            break;
          case 'Discurs d\'odi':
            category = 'hate speech';
            break;
          case 'Informació falsa':
            category = 'false information';
            break;
          case 'Altres':
            category = 'other';
            break;
          default:
            category = 'other';
            break;
        }
        if (comment == '' || comment == null) comment = "L'usuari amb id: $id, no ha deixat cap comentari";
        final response = await dio.post(
          ReportApis.getReportReviewUrl(review.idReview),
          data: {
            'type': category,
            'comment': comment,
          },
        ); 
      return response.statusCode;
      } catch (e) {
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
    return Review(-1, -1, "", "0", 1, "", null);
  }
  

  void toReviewsAgain(Event event) async {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ReviewPage(event),
        );
      },
    );
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReviewPage(event)),
    );*/
  }
  void toUserReviews(bool first) {
    if (!first && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    Navigator.of(context,
        rootNavigator: true)
    .push(
    MaterialPageRoute(
      builder: (context) => MyReview()));
  }
}