// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../controllers/userController.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'styles/custom_snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool login = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 120),
          child: Center(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset('assets/cultura_c2.png', height: 250),
                  SizedBox(height: 30),
                  const Text(
                    'Inicia Sessió',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Correu electrònic'),
                    controller: _emailController,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Contrasenya'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  !login
                      ? Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                //obtengo los valores de los campos
                                String email = _emailController.text;
                                String password = _passwordController.text;
                                setState(() {
                                  login = true;
                                });
                                try {
                                  //llamo a la funcion de login
                                  int statusCode = await userController
                                      .loginUser(email, password);
                                  if (statusCode == 200) {
                                    userController.realize_login(context);
                                  } else {
                                    setState(() {
                                      login = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        customSnackbar(context,
                                            'Usuari i/o contrasenya incorrectes'));
                                  }
                                } catch (error) {
                                  setState(() {
                                    login = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      customSnackbar(context,
                                          'Error de conexió al intentar iniciar la sessió'));
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 8, height: 30),
                                  const Text(
                                    'Login',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              child: Text('Crea un nou compte',
                                  style: TextStyle(color: Colors.redAccent)),
                              onPressed: () async {
                                userController.to_signUp(context);
                              },
                            ),
                            //espacio para el boton de google
                            const SizedBox(height: 20),
                            //un flatbutton para el boton de google
                            SignInButton(
                              Buttons.Google,
                              onPressed: ()  async {
                                await userController.googleLogin(context);
                              },
                            ),
                          ],
                        )
                      : SizedBox(
                          child: SpinKitFadingCircle(
                          size: MediaQuery.of(context).size.height*0.08,
                          color: Colors.redAccent,
                        )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
