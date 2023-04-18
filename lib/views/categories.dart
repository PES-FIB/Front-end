
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'EventList.dart';

class Categories extends StatefulWidget {
  // Define the stateful widget class
  @override
  State<Categories> createState() => _Categories();
}

List<String> Ambits = ["ambit1", "ambit2", "ambit3", "ambit4", "ambit5"];

class _Categories extends State<Categories> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: ListView.builder(
                itemCount: Ambits.length,
                itemBuilder: ((context, index) {
                  return CategoryBox(category: Ambits[index]);
                }),
              ),
            )
          ],
        )
      )
    );
  }
}

class CategoryBox extends StatelessWidget {
  final String category;

  const CategoryBox({ 
    Key? key,
    required this.category,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.redAccent,
      ),
    );
  }
}