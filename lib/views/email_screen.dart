// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/User.dart';

class Contacte extends StatefulWidget {
  const Contacte({Key? key}) : super(key: key);

  @override
  _ContacteState createState() => _ContacteState();
}


class _ContacteState extends State<Contacte> {

final subjectController = TextEditingController();
final messageController = TextEditingController();

Future sendEmail(BuildContext context) async{
  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  const serviceId = "service_8ltqtxj";
  const templateId = "template_b7k7n1i";
  const userId = "vPPeP1TCnCU1zfNL0";
  final response = await http.post(
    url, 
    headers: {
      'origin': 'http://localhost',
      'Content-Type': 'application/json'
      }, 
    body: jsonEncode({
      "service_id":serviceId,
      "template_id":templateId,
      "user_id": userId,
      "template_params": {
        "user": User.name,
        "subject": subjectController.text,
        "user_email": User.email,
        "message":messageController.text,
      }
    })
  );
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Correu enviat correctament!'),
        backgroundColor: Colors.green,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al enviar el correu'),
        backgroundColor: Colors.red,
      ),
    );
  }
  return response.statusCode;
}
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20,),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(25, 40, 25, 0),
          child: Form(
            child: Column(
              children: [
                Text("No dubtis en contactar-nos!"),
                SizedBox(height: 25,),
                TextFormField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.subject),
                    labelText: 'Subjecte', 
                  ),
                ), 
                SizedBox(height: 25,),
                TextFormField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.message),
                    labelText: 'Missatge',
                  ),
                ), 
                SizedBox(height: 30,),
                Builder( // Envuelve el ElevatedButton con un Builder
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      onPressed: () {
                        sendEmail(context); // Llama al método sendEmail con el nuevo BuildContext
                      }, 
                      child: Text("Enviar", style: TextStyle(fontSize: 20),),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey), elevation: MaterialStateProperty.all<double>(0),),
                    );
                  },
                ),
              ],
            )
          ),
        ),
      ),
      
    );
  }
}

