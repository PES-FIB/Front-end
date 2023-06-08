// ignore_for_file: non_constant_identifier_names, curly_braces_in_flow_control_structures, unrelated_type_equality_checks, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../../models/AppEvents.dart';
import '../../models/Review.dart';
import '../../models/Event.dart';
import '../../models/User.dart';
import '../event_screen.dart';
import 'custom_snackbar.dart';
import 'custom_report_form.dart';
import '../../controllers/reviews_controller.dart';


//reviewcard es una clase que se encarga de mostrar una valoración en forma de card
// ignore: non_constant_identifier_names
class ReviewCard extends StatefulWidget {
  final Review review;
  final Event event;

  ReviewCard({required this.review, required this.event});

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  String? username;
  String? idActivity;
  String? contenido;
  String? eventname;

  final reportComment = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username = widget.review.username;
    idActivity = widget.review.idActivity;
    contenido = widget.review.contenido;
    eventname = widget.event.title;
  }

   @override
  void dispose() {
    // Limpia el controlador cuando el widget se descarte
    reportComment.dispose();
    super.dispose();
  }

  final List<String> categories = ['Assatjament', 'Spam', 'Contingut inadequat', 'Discurs d\'odi', 'Informació falsa', 'Altres'];

  
  @override
  Widget build(BuildContext context) {
    final _reviewController = ReviewController(context);
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0), // Añadir espacio alrededor del contenido
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //de moment no es mostra el nom de l'usuari que ha fet la review
            if (username != null)
              ListTile(
                title: Text(
                  'Valoració feta per\n',
                  style: TextStyle(fontSize: 15),
                ),
                subtitle: Text(
                  username!,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold, // Aplicar negrita al nombre de usuario
                    color: Colors.redAccent,
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(contenido!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Alinear la RatingBar al centro
              children: [
                widget.review.buildRatingBar(true), // muestra la puntuación como estrellas
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    radius: 100,
                    child: Text("Reportar valoració"),
                    onTap: () {
                      print("Reportar");
                      print(User.id);
                      print(idActivity);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomReportForm(dropdownValues: categories, review: widget.review);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//listado de todas las valoraciones de un evento
// ignore: non_constant_identifier_names
ListView ReviewList(List<Review> valoracions, Event event) {
  List<Widget> reviewCards = [];
  for (int i = 0; i < valoracions.length; i++) {
    reviewCards.add(ReviewCard(review: valoracions[i], event: event));
  }
  return ListView(
    children: reviewCards,
  );
}

ListView MyReviewsList(BuildContext context, List<Review> valoracions) {
  List<Widget> myReviews = [];
  for (int i = 0; i < valoracions.length; i++) {
    //assegurem que les valoracions don de l'usuari
    if (valoracions[i].userId == User.id) {
      myReviews.add(UserReview(context, valoracions[i]));
    }
  }

  return ListView(
    children: myReviews,
  );
}


Column MakeReview(BuildContext context, Event event) {
  ReviewController _reviewController = ReviewController(context);
  Review valoracionUsuario = Review(User.id, -1, User.name, event.code, 5, "", event.title);
  final reviewController = TextEditingController();
  return Column(
    children: [
      Text("Fes la teva valoració", style: TextStyle(fontSize: 16),),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Escriu que t\'ha semblat l\'activitat'),
        controller: reviewController,
      ),
      SizedBox(height: 8.0),
      Text("Puntua l'event", style: TextStyle(fontSize: 16),),
      SizedBox(height: 15.0),
      Align(
        child: valoracionUsuario.buildRatingBar(false),
      ),
      SizedBox(height: 8.0),
      ElevatedButton(
        child: Text("Enviar"),
        onPressed: () async {
          valoracionUsuario.contenido = reviewController.text;
          print(valoracionUsuario.contenido);
          print(valoracionUsuario.score);
          //añadir la review a la lista de reviews
          final status = await _reviewController.addReview(valoracionUsuario);
          if(status == 200) {
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
      Text("La teva valoració:", style: TextStyle(fontSize: 16),),
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
            child: Text("Delete"),
            onPressed: () async{
              //Eliminar la review de la lista de reviews
              print(valoracionUsuario.idReview);
              final status = await _reviewController.deleteMyReview(valoracionUsuario);
              if(status == 200) {
                ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Valoració eliminada exitosament"));
                _reviewController.toReviewsAgain(event);
              }
              else ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Error al eliminar la valoració"));
            },
          ),
          SizedBox(width: 15.0,),
          ElevatedButton(
          child: Text("Update"),
          onPressed: () async{
            valoracionUsuario.contenido = reviewController.text;
            print(valoracionUsuario.contenido);
            print(valoracionUsuario.score);
            //Actualizar la review en la lista de reviews
            final status = await _reviewController.updateMyReview(valoracionUsuario);
            if(status == 200) {
              ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Valoració actualitzada exitosament"));
              _reviewController.toReviewsAgain(event);
            }
            else ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Error al actualizar la valoració"));
          },
        ),  
        ],
      ),
    ],
  );
}

Card UserReview(BuildContext context, Review review){
  ReviewController _reviewController = ReviewController(context);
  final reviewController = TextEditingController(text: review.contenido);
  final eventname = review.title;
  
  return Card(
    elevation: 5.0,
    child: Padding(
      padding: const EdgeInsets.all(20.0), // Añadir espacio alrededor del contenido
      child: Column(
        children: [
          SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Event:\n", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              InkWell(
                radius: 1000,
                child: Text(eventname!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                onTap: () async {
                  Event? event = AppEvents.eventsList.firstWhereOrNull((event) => event.code == review.idActivity);
                  if (event != null) {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Events(event: event),
                        );
                      },
                    );
                  }   
                },
              ),
            ],
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Edita la teva valoració'),
            controller: reviewController,
          ),
          SizedBox(height: 15.0),
          Align(
            child: review.buildRatingBar(false),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Text("Delete"),
                onTap: () async {
                  // Eliminar la review de la lista de reviews
                  print(review.idReview);
                  final status = await _reviewController.deleteMyReview(review);
                  if (status == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Valoració eliminada exitosament"));
                    _reviewController.toUserReviews(false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Error al eliminar la valoració"));
                  }
                  print("valoració eliminada");
                },
              ),
              SizedBox(width: 120.0),
              InkWell(
                child: Text("Update"),
                onTap: () async {
                  review.contenido = reviewController.text;
                  print(review.contenido);
                  print(review.score);
                  print(review.idReview);
                  // Actualizar la review en la lista de reviews
                  final status = await _reviewController.updateMyReview(review);
                  if (status == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Valoració actualitzada exitosament"));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Error al actualizar la valoració"));
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    ),
  );
}







 
