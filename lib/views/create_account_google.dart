import 'package:flutter/material.dart';

class CreateAccountWithGoogle extends StatelessWidget {
  final String? username;
  final String email;

  const CreateAccountWithGoogle({Key? key, required this.username, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear cuenta'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Nombre de usuario: $username',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Correo electrónico: $email',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para crear una cuenta
              },
              child: Text('Crear cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}
