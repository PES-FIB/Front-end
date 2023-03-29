import 'package:flutter/material.dart';
import 'package:prova_login/controllers/userController.dart';
import 'login_page.dart';
import '../models/User.dart';

class Perfil extends StatefulWidget {
   @override
  State<Perfil> createState() {
    return _PerfilState();
  }
}
class _PerfilState extends State<Perfil> {
   List<User> lu = [];

  @override
  void initState() {
    super.initState();
    loadUser();
  }


  Future<void> loadUser() async {
    User CurrentUser = await userController.getUserInfo();
    setState(() {
      lu.add(CurrentUser);
      print('User loaded');
    });
  }

  @override
  Widget build(BuildContext context) {
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                child: Text(lu[0].email),
              ),
            ],
          ), 
        ),
      ),
    );
  }
}