import 'package:flutter/material.dart';
import './styles/search_bar.dart';
import './styles/custom_dropdownbutton.dart';
import '../controllers/filter_controller.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  FilterController filterController = FilterController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: searchBar(),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text('Filtrar per:'),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: FutureBuilder<List<String>>(
                        future: filterController.getFilters(),
                        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                          if (snapshot.hasData) {
                            return CustomDropdownButton(
                              dropdownValues: snapshot.data!,
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

