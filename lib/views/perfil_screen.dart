// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import '../controllers/perfil_controller.dart';

class Perfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.purple,
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              
              try {
                int statusCode = await PerfilController(context).logutUser();
                if (statusCode == 200) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error al intentar cerrar la sessión', style: TextStyle(fontSize: 20 ,color: Colors.red), ),
                    ),
                  );
                }
              }
              catch (e) {
                print(e);
              }   
            },
            child: Text('Logout'),
          ),
        ),
      ),
    );
  }
}