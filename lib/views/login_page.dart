import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../controllers/userController.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'styles/custom_snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool login = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initLogin();
  }

  Future<void> _initLogin() async {
    bool isLoggedIn = await userController(context).initPrefs();
    setState(() {
      login = isLoggedIn;
      if (login) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(context, 'Sessió de l\'usuari recuperada correctament'));
      }
    });
  }

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
                  Visibility(
                    visible: !login,
                    child: const Text(
                      'Inicia Sesión',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: !login,
                    child: Column(
                      children: [
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
                      ],
                    ),
                  ),
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
                                // Obtener los valores de los campos
                                String email = _emailController.text;
                                String password = _passwordController.text;
                                try {
                                  // Llamar a la función de inicio de sesión
                                  int statusCode = await UserController.loginUser(email, password);
                                  if (statusCode == 200) {
                                    setState(() {
                                      login = true;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        customSnackbar(context, 'Usuari loguejat correctament'));
                                    UserController.realize_login(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        customSnackbar(context,
                                            'Usuari i/o contrasenya incorrectes'));
                                  }
                                } catch (error) {
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
                                UserController.to_signUp(context);
                              },
                            ),
                            const SizedBox(height: 20),
                            SignInButton(
                              Buttons.Google,
                              onPressed: () async {
                                bool success = await UserController.googleLogin(context);
                                if (success) {
                                  setState(() {
                                    login = true;
                                  });
                                  // ignore: use_build_context_synchronously
                                  UserController.realize_login(context);
                                }
                              },
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              child: SpinKitFadingCircle(
                                size: MediaQuery.of(context).size.height * 0.08,
                                color: Colors.redAccent,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Carregant els events...',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
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
