import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:prova_login/controllers/userController.dart';
import 'login_page.dart';
import '../models/User.dart';
import 'perfil_screen.dart';
import 'styles/custom_snackbar.dart';

class PerfilConfig extends StatefulWidget {
   @override
  State<PerfilConfig> createState() {
    return _PerfilConfigState();
  }
}
class _PerfilConfigState extends State<PerfilConfig> {
  bool editName = false;
  bool editEmail = false;
  bool editPassword = false;
  bool loadingUpdate = false;
  TextEditingController _nameController = TextEditingController(text: User.name);
  TextEditingController _emailController = TextEditingController(text: User.email);
  TextEditingController _passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column (
        children: [
          Row(
            children: [
              IconButton (
                tooltip: 'Torna al perfil',
                style: IconButton.styleFrom(
                    shape: CircleBorder()
                ),
                onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Perfil())).then((_) {
                      setState(() {
                      });
                    });
                },
                icon: Icon(Icons.arrow_back, color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text('Configuració', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          SizedBox(height: 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
                  Text('Nom:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(width: 40),
                  SizedBox(
                    width: 200,
                    height:20,
                  child : TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                    ),
                    controller: _nameController,
                    enabled: editName
                  ),
                  ),
                  SizedBox(width: 30),
                  Flexible(
                  child: IconButton(
                    onPressed: () {
                    setState(() {
                      editName = true;
                    });
                    },
                    icon: Icon(Icons.edit)
                    ),
                  ),
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
                  Text('Email:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(width: 40),
                  SizedBox(
                    width: 200,
                    height:20,
                  child : TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                    ),
                    controller: _emailController,
                    enabled: editEmail,
                    
                  ),
                  ),
                  SizedBox(width: 30),
                  Flexible(
                  child: IconButton(
                    onPressed: () {
                    setState(() {
                      editEmail = true;
                    });
                    },
                    icon: Icon(Icons.edit)
                    ),
                  ),
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
                  Text('Nova \nContrasenya:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(width: 5),
                  SizedBox(
                    width: 200,
                    height:20,
                  child : TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                    ),
                    controller: _passwordController,
                    enabled: editPassword,
                    obscureText: true,
                  ),
                  ),
                  SizedBox(width: 20),
                  Flexible(
                  child: IconButton(
                    onPressed: () {
                    setState(() {
                      editPassword = true;
                    });
                    },
                    icon: Icon(Icons.edit)
                    ),
                  ),
            ]
          ),
          SizedBox(height: 40),
          ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            fixedSize:Size(220, 50)
          ),
          onPressed: () async {
            setState(() {
              loadingUpdate = true;
            });
            if(_nameController.text.isNotEmpty && _emailController.text.isNotEmpty && !(_nameController.text == User.name) && !(_emailController.text == User.email)) {
              try {

                await userController.updateUserInfo(_nameController.text,_emailController.text);
              }
              catch(error) {
                setState(() {
                  loadingUpdate = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'No s\'han pogut actualitzar les dades, reviseu-les.'));
              }
              finally {
                setState(() {
                  loadingUpdate = false;
                });
              ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'Dades Actualitzades correctament'));
              }
            }
            else {
              ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'El correu/contrasenya són buits o no s\'han canviat'));
              setState(() {
                  loadingUpdate = false;
              });
            }
          },
            child: loadingUpdate?
            CircularProgressIndicator():
            Text('Actualitza les meves dades'),
          ),
        ],
      )
    );
  }
}