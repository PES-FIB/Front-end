import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:prova_login/controllers/userController.dart';
import 'login_page.dart';
import '../models/User.dart';
import 'perfil_screen.dart';

class PerfilConfig extends StatefulWidget {
   @override
  State<PerfilConfig> createState() {
    return _PerfilConfigState();
  }
}
class _PerfilConfigState extends State<PerfilConfig> {

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
        color: Colors.blue,
        child: Center(
          child: Text('Map'),
        ),
        ),
      );
  }
}