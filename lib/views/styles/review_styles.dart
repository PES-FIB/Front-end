// ignore_for_file: non_constant_identifier_names, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import '../../models/Review.dart';
import '../../models/Event.dart';
import '../../models/User.dart';
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

  final List<String> categories = ['harassment', 'spam', 'inappropriate content', 'hate speech', 'false information', 'other'];

  
  @override
  Widget build(BuildContext context) {
    final _reviewController = ReviewController(context);
    return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text('Valoració feta per $username'),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(contenido!),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: widget.review.buildRatingBar(true),    // muestra la puntuación como estrellas
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
                  final reportComment = TextEditingController();

                  print("Reportar");
                  print(User.id);
                  print(idActivity);

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDropdownButton(dropdownValues: categories);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );

  }
}

//listado de todas las valoraciones de un evento
// ignore: non_constant_identifier_names
ListView ReviewList(List<Review> valoracions, Event event) {
  List<Widget> reviewCards = [];
  for (int i = 0; i < valoracions.length; i++) {
    if (valoracions[i].userId != User.id) {
      reviewCards.add(ReviewCard(review: valoracions[i], event: event));
    }
  }

  return ListView(
    children: reviewCards,
  );
}


Column MakeReview(BuildContext context, Event event) {
  ReviewController _reviewController = ReviewController(context);
  Review valoracionUsuario = Review(User.id, -1, User.name, event.code, 5, "");
  final reviewController = TextEditingController();
  return Column(
    children: [
      Text("Fes la teva valoració", style: TextStyle(fontSize: 20),),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Escriu que t\'ha semblat l\'activitat'),
        controller: reviewController,
      ),
      Text("Puntua l'event", style: TextStyle(fontSize: 16),),
      SizedBox(height: 15.0),
      Align(
        child: valoracionUsuario.buildRatingBar(false),
      ),
      SizedBox(height: 15.0),
      ElevatedButton(
        child: Text("Enviar"),
        onPressed: () {
          valoracionUsuario.contenido = reviewController.text;
          print(valoracionUsuario.contenido);
          print(valoracionUsuario.score);
          //añadir la review a la lista de reviews
          //bool status = _reviewController.addReview(valoracionUsuario) as bool;
          //if(status) {
            //ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Valoració enviada exitosament"));
            //_reviewController.toReviewsAgain(event);
          //}
          //else ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Error al realizar la valoració"));
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
              //bool status = _reviewController.updateMyReview(valoracionUsuario) as bool;
              //if(status) {
                //ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Valoració actualitzada exitosament"));
                //_reviewController.toReviewsAgain(event);
              //}
              //else ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Error al actualizar la valoració"));
            },
          ),
          SizedBox(width: 15.0,),
          ElevatedButton(
            child: Text("Delete"),
            onPressed: () {
              //Eliminar la review de la lista de reviews
              print(valoracionUsuario.idReview);
              //bool status = _reviewController.deleteMyReview(valoracionUsuario) as bool;
              //if(status) {
                //ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Valoració eliminada exitosament"));
                //_reviewController.toReviewsAgain(event);
              //}
              //else ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Error al eliminar la valoració"));
              print("valoració eliminada");
            },
          ),
        ],
      ),
    ],
  );
}





 

