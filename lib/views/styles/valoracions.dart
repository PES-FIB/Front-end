import 'package:flutter/material.dart';
import 'package:prova_login/models/Valoration.dart';
import '../../controllers/valoracions_controller.dart';

//reviewcard es una clase que se encarga de mostrar una valoración en forma de card
// ignore: non_constant_identifier_names
Card ReviewCard(Valoracion valoracion) {
  final username = valoracion.username;
  final idActivity = valoracion.idActivity;
  final contenido = valoracion.contenido;

  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Icons.star),
          title: Text('Valoración de $username'),
          subtitle: Text('Actividad: $idActivity'),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(contenido),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: valoracion.buildRatingBar(false),    // muestra la puntuación como estrellas
        ),
      ],
    ),
  );
}

//llistar todas las valoracionse de una actividad

 

