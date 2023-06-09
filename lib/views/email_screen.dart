import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Contacte extends StatefulWidget {
  const Contacte({Key? key}) : super(key: key);

  @override
  _ContacteState createState() => _ContacteState();
}

final nameController = TextEditingController();
final subjectController = TextEditingController();
final emailController = TextEditingController();
final messageController = TextEditingController();

Future sendEmail() async{
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
        "user": nameController.text,
        "subject": subjectController.text,
        "user_email": emailController.text,
        "message":messageController.text,
      }
    })
  );
  print(response.statusCode);
  return response.statusCode;
}


class _ContacteState extends State<Contacte> {
  

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
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.account_circle),
                    hintText: 'Name',
                    labelText: 'Name',
                  ),
                ), 
                SizedBox(height: 25,),
                TextFormField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.subject_rounded),
                    hintText: 'Subject',
                    labelText: 'Subject',
                  ),
                ), 
                SizedBox(height: 25,),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'Email',
                    labelText: 'Email',
                  ),
                ), 
                SizedBox(height: 25,),
                TextFormField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.message),
                    hintText: 'Message',
                    labelText: 'Message',
                  ),
                ), 
                SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: (){sendEmail();}, 
                  child: Text("Enviar", style: TextStyle(fontSize: 20),),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent), elevation: MaterialStateProperty.all<double>(0),),
                )
              ],
            )
          ),
        ),
      ),
      
    );
  }
}

