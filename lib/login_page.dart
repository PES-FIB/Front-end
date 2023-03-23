// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';
import 'create_account.dart';
import 'dart:async';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  Future<bool> _checkUser(String email, String password) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/v1/apitest/users/$email'));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['password'] == password) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }
    
  void _login(String email, String password) {    
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  void _singUp() {
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        //obtengo los valores de los campos
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        if (await _checkUser(email, password)) {
                          _login(email, password);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Usuario i/o contraseña incorrectos', style: TextStyle(fontSize: 20 ,color: Colors.red), ),
                            ),
                          );
                        }
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