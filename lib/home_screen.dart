import 'package:flutter/material.dart';
import 'UserList.dart';

class Home extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold( 
        body: UserList(),
      )



      //una barra de búsqueda
      /*
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text('Filtrar per:'),
                      ),
                    //caja para seleccionar el tipo de filtro
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: DropdownButton(
                        hint: Text('Selecciona un filtre', style: TextStyle(fontSize: 16)),

                        items: [
                          DropdownMenuItem(
                            value: 1,
                            child: Text('Data'),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text('Hora'),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text('Localització'),
                          ),
                        ],
                        onChanged: (value) {
                          //cambiar hint
                          

                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ), */
    );
  }
}