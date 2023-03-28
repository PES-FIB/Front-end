import 'package:flutter/material.dart';
import 'package:prova_login/controllers/userController.dart';
import 'login_page.dart';
import '../models/User.dart';

class Perfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future u = userController.getUserInfo();
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
        color: Color.fromARGB(255, 223, 221, 221),
        borderRadius: BorderRadius.circular(3.0),
        ),
        child: Center(
          child:  Column(
            children: <Widget> [
              ElevatedButton (
                onPressed: () async {
                  int response = 0;
                  try {
                    response = await userController.logOut();
                  }
                  catch(e) {
                    print(e);
                  }
                  finally {
                    if (response == 200) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                  child: Text('Logout'),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton (
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  ), 
                  backgroundColor: Colors.blue,
                ),
                onPressed: () async {
                  User u = await userController.getUserInfo();
                  if (u.getEmail() != 'null') {
                  Text(u.getEmail());
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                  child: Text('Dades Usuari'),
                ),
              ),
            ],
          ), 
        ),
      ),
    );
  }
}