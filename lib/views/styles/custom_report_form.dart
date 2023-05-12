// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:prova_login/models/Review.dart';
import '../../models/User.dart';
import 'custom_snackbar.dart';
import '../../controllers/reviews_controller.dart';

class CustomReportForm extends StatefulWidget {
  final List<String> dropdownValues;
  final Review review;

  CustomReportForm({
    required this.dropdownValues,
    required this.review,
  });

  @override
  CustomReportFormState createState() => CustomReportFormState();
}

class CustomReportFormState extends State<CustomReportForm> {
  String? selectedValue;
  final reportComment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final ReviewController _reviewController = ReviewController(context);
    return 
    AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Selecciona el tipus de report que vols fer', textAlign: TextAlign.center,),
          SizedBox(height: 16,),
          DropdownButton<String>(
            value: selectedValue,
            hint: Text('Escull un'),
            onChanged: (newValue) {
              setState(() {
                selectedValue = newValue!;
              });
            },
            items: widget.dropdownValues.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 16,),
          TextField(
            controller: reportComment,
            decoration: InputDecoration(
              hintText: "Escriu aqui el motiu (opcional)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            maxLines: 4,
          )
        ],
      ),
      actions: [
        ElevatedButton(
          child: Text('Cancelar'),
          onPressed: () {
            print("report cancelled");
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Aceptar'),
          onPressed: () async {
            if (selectedValue == null) {
              ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Error al crear el report, necesites escullir un tipus de report"));
            } else {
              print(selectedValue);
              print(reportComment.text);
              print(User.id);
              final status = await _reviewController.reportReview(widget.review, selectedValue!, reportComment.text);
              if (status == 200) ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Valoració reportada exitosament"));
              else if(status == 400) ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Error al reportar la valoració, ja has reportat aquesta valoració"));
              else if(status == 404) ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Error al reportar la valoració, no existeix la valoració"));
              else ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Error al reportar la valoració"));
            }
            Navigator.of(context).pop();
            
          },
        ),
      ],
    );
  }
}


