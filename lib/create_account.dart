import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'main_screen.dart';
import '../controllers/CreateAccountController.dart';


class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Culturica\'t'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children:<Widget> [
              Flexible(child: Image.asset('assets/Captura.png', height: 200.0)),
              SizedBox(height: 20),
              MyCustomForm(),
                ]
              ),
            ),
        ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final CreateAccountController createAccountController = CreateAccountController(context);
    // Build a Form widget using the _formKey created above.
    String errorMessage = '';
    return Form(
      key: _formKey,
      child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Text(
          'Crea el teu compte a Culturica\'t',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _nameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            return null;
          },
          decoration: const InputDecoration(labelText: 'Nom i Cognoms'),
        ),
        TextFormField(
          controller: _emailController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            return null;
          },
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        TextFormField(
          controller: _passwordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            else if(value.isNotEmpty && value !=_password2Controller.text) {
              _passwordController.clear();
            }
            return null;
          },
          decoration: const InputDecoration(labelText: 'Contrasenya'),
          obscureText: true,
        ),
        TextFormField(
          controller: _password2Controller,
          validator: (value) {
            if (value != _passwordController.text && !((value == null || value.isEmpty)) ) {
              _password2Controller.clear();
              return 'La contrasenya indicada no coincideix';
            }
            else if ((value == null || value.isEmpty) && _passwordController.text.isNotEmpty ) {
              return 'Siusplau, confirmi la seva contrasenya';
            } 
            else if ((value == null || value.isEmpty) && _passwordController.text.isEmpty) {
              return '';
            }
            return null;
          },
          decoration: const InputDecoration(labelText: 'Repeteixi la seva contrasenya'),
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
            if (_formKey.currentState!.validate()) {
              try {
                await createAccountController.signUp(_nameController.text, _emailController.text, _passwordController.text);
             }
             catch (error) {

             }
            }
          },
          child: Text('Crear un nou Compte'),
        ),
      ],
      ),
    );
  }
}