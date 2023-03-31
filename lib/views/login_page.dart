// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../controllers/login_page_controller.dart';

import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'styles/custom_snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final LoginPageController loginPageController = LoginPageController(context);

    return Scaffold(
      body: SingleChildScrollView(
        child:Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 120),
            child: Center(
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.asset('assets/culturicat-removebg-preview.png', height: 270),
                    const Text(
                      'Inicia Sessió',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      controller: _emailController,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
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
                        try {
                          //llamo a la funcion de login
                          int statusCode = await loginPageController.loginUser(email, password);
                          if (statusCode == 200) {
                            loginPageController.realize_login();
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'Usuario i/o contraseña incorrectos'));
                          }
                        }
                        catch(error) {
                          print(error);
                          ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'Fallo de connexión al intentar iniciar sesión'));
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
                      child: Text('Crear una nueva cuenta', style: TextStyle(color: Colors.redAccent) ),
                      onPressed: () {
                        loginPageController.to_signUp();
                      },
                    ),
                    //espacio para el boton de google
                    const SizedBox(height: 20),
                    //un flatbutton para el boton de google
                    SignInButton(
                      Buttons.Google,
                      onPressed: () {
                        //loginPageController.googleLogin();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
      ),
      );
  }
}
