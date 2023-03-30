import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      hint: Text('Elige un filtro'),
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
    );
  }
}


