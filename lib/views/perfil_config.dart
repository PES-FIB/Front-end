import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:prova_login/controllers/userController.dart';
import 'login_page.dart';
import '../models/User.dart';
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
  int pageStatus = 0;
  bool baixaCheck = false;
  TextEditingController _nameController = TextEditingController(text: User.name);
  TextEditingController _emailController = TextEditingController(text: User.email);
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _newPasswordControllerRepeat = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
        child: Scaffold(
          appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.redAccent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "C U L T U R I C A 'T",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
          body:Column (
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton (
                tooltip: 'Torna al perfil',
                style: IconButton.styleFrom(
                    shape: CircleBorder()
                ),
                onPressed: () {
                    Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back, color: Colors.black),
              ),
              Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.005, right:MediaQuery.of(context).size.width*0.054), 
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
                            pageStatus = 1;
                          });
                        },
                        icon: Icon(LineAwesomeIcons.user_minus, color: Colors.white),
                      )
                  ),)
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right:MediaQuery.of(context).size.width*0.025),
              child:
              Row( 
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Donar-se \nde baixa')
                ],
                )
            ),
          pageStatus == 0?
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
                  Text('Canviar la contrasenya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(width: 5),
                  Flexible(
                  child: IconButton(
                    onPressed: () {
                    setState(() {
                      pageStatus= 2;
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
            if(_nameController.text.isNotEmpty && _emailController.text.isNotEmpty && (!(_nameController.text == User.name) || !(_emailController.text == User.email))) {
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
          ):
          pageStatus == 1 ?
          Column(
            children: [
              SizedBox(height: 90),
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
                    pageStatus= 0;
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
                    pageStatus = 0;
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 140),
              Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
                  Text('Contrasenya antiga:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(width: 20),
                  SizedBox(
                    width: 150,
                    height:20,
                  child : TextField(
                    obscureText: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                    ),
                    controller: _passwordController,
                  ),
                  ),
            ]
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
                  Text('Nova Contrasenya:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(width: 20),
                  SizedBox(
                    width: 150,
                    height:20,
                  child : TextField(
                    obscureText: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                    ),
                    controller: _newPasswordController,
                  ),
                  ),
            ]
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
                  Text('Repeteixi la \nnova contrasenya:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(width: 20),
                  SizedBox(
                    width: 150,
                    height:20,
                  child : TextField(
                    obscureText: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                    ),
                    controller: _newPasswordControllerRepeat,
                  ),
                  ),
            ]
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  fixedSize:Size(120, 50),
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () async {
                  if (_newPasswordController.text == _newPasswordControllerRepeat.text) {
                    bool res = false;
                    try {
                      res = await userController.updateUserPassword(_passwordController.text, _newPasswordController.text);
                    }
                    catch (error){
                      ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'Hi ha hagut un error en canviar la contrasenya'));
                    }
                    finally {
                      if (res) {
                        ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'S\'ha actualitzat correctament la contrasenya'));
                        setState(() {
                          pageStatus = 0;
                        });
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'Hi ha hagut un error en canviar la contrasenya'));
                      }
                    }
                  }
                  else if(_passwordController.text.isEmpty || _newPasswordController.text.isEmpty || _newPasswordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'Ompli tots els camps correctament'));
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'La nova contrasenya no coincideix'));
                  }
                },
                child: Text('Canviar Contrasenya')
              ),
              SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  fixedSize:Size(100, 50),
                  backgroundColor: Colors.redAccent
                ),
                onPressed: (){
                  setState(() {
                    pageStatus = 0;
                  });
                },
                child: Text('Cancel·lar')
          )
            ],)
          ],)
        ],
      )
      )
    );
  }
}