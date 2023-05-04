// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import '../../models/Review.dart';
import '../../models/Event.dart';
import '../../models/User.dart';

//reviewcard es una clase que se encarga de mostrar una valoración en forma de card
// ignore: non_constant_identifier_names
Card ReviewCard(Review review, Event event) {
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
          subtitle: Text('Activitat valorada: $eventname'),
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
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// ignore: non_constant_identifier_names
ListView ReviewList(List<Review> valoracions, Event event) {
  return ListView.builder(
    itemCount: valoracions.length,
    itemBuilder: (context, index) {
      return ReviewCard(valoracions[index], event);
    },
  );
}

Column MakeReview(Event event) {
  Review valoracionUsuario = Review(User.name, event.code, 1, "");
  final _reviewController = TextEditingController();
  return Column(
    children: [
      Text("Fes la teva valoració", style: TextStyle(fontSize: 20),),
      SizedBox(height: 15.0),
      Align(
        child: valoracionUsuario.buildRatingBar(false),
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Escriu que t\'ha semblat l\'activitat'),
        controller: _reviewController,
      ),
      SizedBox(height: 15.0),
      ElevatedButton(
        child: Text("Enviar"),
        onPressed: () {
          valoracionUsuario.contenido = _reviewController.text;
          print(valoracionUsuario.contenido);
          //añadir la review a la lista de reviews

        },
      ),
    ],
  );
}

Column MyReview(Event event, Review review) {
  Review valoracionUsuario = review;
  final _reviewController = TextEditingController();
  return Column(
    children: [
      Text("La teva valoració:", style: TextStyle(fontSize: 20),),
      SizedBox(height: 15.0),
      Align(
        child: valoracionUsuario.buildRatingBar(true),
      ),
      TextFormField(
        initialValue: review.contenido,
        decoration: const InputDecoration(labelText: 'Edita la teva valoració'),
        controller: _reviewController,
      ),
      SizedBox(height: 15.0),
      Row(
        //botones para borrar una review y para editarla
        children: [
          ElevatedButton(
            child: Text("Actualitzar valoració"),
            onPressed: () {
              valoracionUsuario.contenido = _reviewController.text;
              print(valoracionUsuario.contenido);
              //Actualizar la review en la lista de reviews
            },
          ),
          ElevatedButton(
            child: Text("Eliminar valoració"),
            onPressed: () {
              //Eliminar la review de la lista de reviews
              print("valoració eliminada");
            },
          ),
        ],
      ),
    ],
  );
}





 

