import 'package:flutter/material.dart';
import '../../models/User.dart';
import 'custom_snackbar.dart';
import '../../controllers/reviews_controller.dart';

class CustomDropdownButton extends StatefulWidget {
  final List<String> dropdownValues;

  CustomDropdownButton({
    required this.dropdownValues,
  });

  @override
  CustomDropdownButtonState createState() => CustomDropdownButtonState();
}

class CustomDropdownButtonState extends State<CustomDropdownButton> {
  String? selectedValue;
  final reportComment = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                print(selectedValue);
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
            print(selectedValue);
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Aceptar'),
          onPressed: () {
            print(selectedValue);
            if (selectedValue == null) {
              ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Error al crear el report, necesites escullir un tipus de report"));
            } else {
              print(reportComment.text);
              print(User.id);
              //bool status = _reviewController.reportReview(widget.review, selectedCategory, reportComment.text) as bool;
              //if (status) ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Valoració reportada exitosament"));
              //else ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, "Error al reportar la valoració"));
            }
            Navigator.of(context).pop();
            
          },
        ),
      ],
    );
  }
}


