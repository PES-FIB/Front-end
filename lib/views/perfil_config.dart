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
  bool baixaCheck = false;
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
              SizedBox(width: 300),
              Padding(padding: EdgeInsets.only(top: 10), 
              child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.redAccent,
                      child: IconButton (
                        tooltip: 'Donar-se de baixa',
                        style: IconButton.styleFrom(
                            shape: CircleBorder()
                        ),
                        onPressed:() {
                          setState(() {
                            baixaCheck = true;
                          });
                        },
                        icon: Icon(LineAwesomeIcons.user_minus, color: Colors.white),
                      )
                  ),)
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right:11),
              child:
              Row( 
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Donar-se \nde baixa')
                ],
                )
            ),
          baixaCheck?
          Column(
            children: [
              SizedBox(height: 100),
              Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text('Està segur que vol donar-se de baixa?'),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  fixedSize:Size(50, 50),
                  backgroundColor: Colors.redAccent
                ),
                onPressed: () async {
                  bool check = false;
                  try {
                  check = await userController.deleteUser(User.id);
                  }
                  catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'Hi ha hagut un error en donar-se de baixa'));
                  }
                  finally {
                  if (check) {
                    Navigator.of(context, rootNavigator: true).pushReplacement(                          
                          MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'Hi ha hagut un error en donar-se de baixa'));
                  }
                  setState(() {
                    baixaCheck = false;
                  });
                  }
                },
                child: Text('Si')
                ),
                SizedBox(width: 40),
                ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  fixedSize:Size(50, 50),
                  backgroundColor: Colors.redAccent
                ),
                onPressed: () {
                  setState(() {
                    baixaCheck = false;
                  });
                },
                child: Text('No')
                ),
                    ],
                  )
                ],
              )
            ],
          )
            ],
          ):
          Expanded(
            child: Column(
              children: [
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
          loadingUpdate?
            CircularProgressIndicator():
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
              bool b = false;
              try {
               b = await userController.updateUserInfo(_nameController.text,_emailController.text);
              }
              catch(e) {
                setState(() {
                  loadingUpdate = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'No s\'han pogut actualitzar les dades, reviseu-les.'));
              }
              finally { 
                if (b) {
                  setState(() {
                    loadingUpdate = false;
                  });
                ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'Dades Actualitzades correctament'));
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'No s\'han pogut actualitzar les dades, reviseu-les.'));
                  setState(() {
                    loadingUpdate = false;
                  });
                }
              }
            }
            else {
              ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'El correu/contrasenya són buits o no s\'han canviat'));
              setState(() {
                  loadingUpdate = false;
              });
            }
          },
            child: Text('Actualitza les meves dades'),
          ),
          SizedBox(height: 30),
          ],
            )
          ),
        ],
      )
    );
  }
}