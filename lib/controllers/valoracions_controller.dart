import 'package:flutter/material.dart';
import 'dioController.dart';
import '../models/Valoration.dart';


class ReviewController{
  final BuildContext context;
  ReviewController(this.context);

  Future<List<Valoracion>> getReviews(int idActivity) async {
    final response = await dio.get('/reviews/$idActivity');
    final List<Valoracion> reviews = [];
    for (var review in response.data) {
      reviews.add(Valoracion(review['username'], review['idActivity'], review['score'], review['contenido']));
    }
    return reviews;
  }

  Future<bool> addReview(Valoracion review) async {
    final response = await dio.post('/reviews', data: review);
    return response.statusCode == 200;
  }



  
}
