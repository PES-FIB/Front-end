import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../views/styles/custom_snackbar.dart';
import 'main_screen.dart';
import '../controllers/userController.dart';

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
          toolbarHeight: 70,
          title: Text(
            "C U L T U R I C A 'T",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Image.asset('assets/cultura_c2.png', height: 250.0, width: 300),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: MyCustomForm()),
              ],
            ),
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
  bool createAccount = false;
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
    // Build a Form widget using the _formKey created above.
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
              } else if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value)) {
                return 'Introdueixi un correu vàlid.';
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
              } else if (value.isNotEmpty &&
                  value != _password2Controller.text) {
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
              if (value != _passwordController.text &&
                  !((value == null || value.isEmpty))) {
                _password2Controller.clear();
                return 'La contrasenya indicada no coincideix';
              } else if ((value == null || value.isEmpty) &&
                  _passwordController.text.isNotEmpty) {
                return 'Siusplau, confirmi la seva contrasenya';
              } else if ((value == null || value.isEmpty) &&
                  _passwordController.text.isEmpty) {
                return '';
              }
              return null;
            },
            decoration: const InputDecoration(
                labelText: 'Repeteixi la seva contrasenya'),
            obscureText: true,
          ),
          const SizedBox(height: 30),
          !createAccount
              ? Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        fixedSize: Size(200, 50)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          createAccount = true;
                        });
                        int response = 0;
                        try {
                          response = await UserController.signUp(
                              _nameController.text,
                              _emailController.text,
                              _passwordController.text);
                        } catch (error) {
                          setState(() {
                          createAccount = true;
                        });
                          ScaffoldMessenger.of(context).showSnackBar(
                                        customSnackbar(context,
                                            'Usuario i/o contraseña incorrectos'));
                        } finally {
                          if (response == 201) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen()),
                            );
                          }
                        }
                      }
                    },
                    child: Text('Crear un nou Compte'),
                  ),
                )
              : SizedBox(
                  child: SpinKitFadingCircle(
                  size: MediaQuery.of(context).size.height * 0.08,
                  color: Colors.redAccent,
                )),
        ],
      ),
    );
  }
}
