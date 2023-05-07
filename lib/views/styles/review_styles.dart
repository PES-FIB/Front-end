// ignore_for_file: non_constant_identifier_names, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import '../../models/Review.dart';
import '../../models/Event.dart';
import '../../models/User.dart';
import 'custom_snackbar.dart';

import '../../controllers/reviews_controller.dart';


//reviewcard es una clase que se encarga de mostrar una valoración en forma de card
// ignore: non_constant_identifier_names
Card ReviewCard(BuildContext context, Review review, Event event) {
  ReviewController _reviewController = ReviewController(context);
  final username = review.username;
  final idActivity = review.idActivity;
  final contenido = review.contenido;

  final eventname = event.title;

  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text('Valoració feta per $username'),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(contenido),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: review.buildRatingBar(true),    // muestra la puntuación como estrellas
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                radius: 100,
                child: Text("Reportar valoració"),
                onTap: () {
                  //reportar comentario
                  print("Reportar");
                  print(User.id);
                  print(review.idActivity);
                  //aqui se hace la llamada
                  bool status = _reviewController.reportReview(review) as bool;
                  //mostrar mensage de que se ha reportado
                  if (status) ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Valoració reportada exitosament"));
                  else ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Error al reportar la valoració"));
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

//listado de todas las valoraciones de un evento
// ignore: non_constant_identifier_names
ListView ReviewList(List<Review> valoracions, Event event) {
  return ListView.builder(
    itemCount: valoracions.length,
    itemBuilder: (context, index) {
      return ReviewCard(context,valoracions[index], event);
    },
  );
}

Column MakeReview(BuildContext context, Event event) {
  ReviewController _reviewController = ReviewController(context);
  Review valoracionUsuario = Review(User.id, -1, User.name, event.code, 1, "");
  final reviewController = TextEditingController();
  return Column(
    children: [
      Text("Fes la teva valoració", style: TextStyle(fontSize: 20),),
      SizedBox(height: 15.0),
      Align(
        child: valoracionUsuario.buildRatingBar(false),
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Escriu que t\'ha semblat l\'activitat'),
        controller: reviewController,
      ),
      SizedBox(height: 15.0),
      ElevatedButton(
        child: Text("Enviar"),
        onPressed: () {
          valoracionUsuario.contenido = reviewController.text;
          print(valoracionUsuario.contenido);
          print(valoracionUsuario.score);
          //añadir la review a la lista de reviews
          bool status = _reviewController.addReview(valoracionUsuario) as bool;
          if(status) {
            ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Valoració enviada exitosament"));
            _reviewController.toReviewsAgain(event);
          }
          else ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Error al realizar la valoració"));
        },
      ),
    ],
  );
}

Column MyReview(BuildContext context, Event event, Review review) {
  ReviewController _reviewController = ReviewController(context);
  Review valoracionUsuario = review;
  final reviewController = TextEditingController(text: review.contenido);
  return Column(
    children: [
      Text("La teva valoració:", style: TextStyle(fontSize: 20),),
      SizedBox(height: 15.0),
      Align(
        child: valoracionUsuario.buildRatingBar(false),
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Edita la teva valoració'),
        controller: reviewController,
      ),
      SizedBox(height: 15.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        //botones para borrar una review y para editarla
        children: [
          ElevatedButton(
            child: Text("Update"),
            onPressed: () {
              valoracionUsuario.contenido = reviewController.text;
              print(valoracionUsuario.contenido);
              print(valoracionUsuario.score);
              //Actualizar la review en la lista de reviews
              bool status = _reviewController.updateMyReview(valoracionUsuario) as bool;
              if(status) {
                ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Valoració actualitzada exitosament"));
                _reviewController.toReviewsAgain(event);
              }
              else ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Error al actualizar la valoració"));
            },
          ),
          SizedBox(width: 15.0,),
          ElevatedButton(
            child: Text("Delete"),
            onPressed: () {
              //Eliminar la review de la lista de reviews
              print(valoracionUsuario.idReview);
              bool status = _reviewController.deleteMyReview(valoracionUsuario) as bool;
              if(status) {
                ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Valoració eliminada exitosament"));
                _reviewController.toReviewsAgain(event);
              }
              else ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Error al eliminar la valoració"));
              print("valoració eliminada");
            },
          ),
        ],
      ),
    ],
  );
}





 

