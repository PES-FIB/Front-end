import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'create_account.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    // Implementación del inicio de sesión aquí
    final dio = Dio();
    //Login mentre no esta tot a prod
    try {
    await dio.post('http://nattech.fib.upc.edu:40331/api/v1/auth/login', 
    data: {'email':'gerard.g@gmail.com', 'password':'gerard1234'});
    }
    on DioError catch (e) {
      print(e.message);
    }
    //
   finally {
    // Después de iniciar sesión, navegar a la siguiente pantalla
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
   }
  }

  void _singUp() {
    // Implementación de la creación de una nueva cuenta aquí

    // Después de crear una nueva cuenta, navegar a la siguiente pantalla
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateAccount()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      'Email',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                          _login() ;
                      },
                      child: Text('Login'),
                    ),
                    TextButton(
                      child: Text('Crear una nueva cuenta'),
                      onPressed: () {
                        _singUp();
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final TextEditingController controller;

  const MyTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(fontSize: 14),
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: 'Insereixi el seu correu electrònic',
      ),
    );
  }
}
