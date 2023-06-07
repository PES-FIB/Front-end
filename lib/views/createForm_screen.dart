import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prova_login/controllers/eventsController.dart';
import 'package:prova_login/controllers/taskController.dart';
import 'package:prova_login/controllers/userController.dart';
import 'styles/custom_snackbar.dart';
import 'package:image_picker/image_picker.dart';


class createForm extends StatefulWidget {
  const createForm({
    Key? key,
    //required this.onNavigate,
  }) : super(key: key);

  @override
  _createFormState createState() => _createFormState();
}

class _createFormState extends State<createForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController denominationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ticketsController = TextEditingController();
  TextEditingController scheduleController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  late DateTime dataIni = DateTime.now();
  late DateTime dataFi = DateTime.now();
  XFile? imageEvent = null;

  Future<void> selectImage () async {
    imageEvent = await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: Text(
        'Formulari de sol·licitud d\'event',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: 'Títol de la sol·licitud',
                      labelStyle: TextStyle(fontSize: 12)),
                ),
                TextFormField(
                  controller: denominationController,
                  decoration: const InputDecoration(
                      labelText: 'Nom de l\'event',
                      labelStyle: TextStyle(fontSize: 12)),
                ),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      labelText: 'Descripció',
                      labelStyle: TextStyle(fontSize: 12)),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: 'Correu electrònic de contacte',
                      labelStyle: TextStyle(fontSize: 12)),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                      child: TextButton(
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: CupertinoDatePicker(
                                backgroundColor: Colors.white,
                                initialDateTime: dataIni,
                                onDateTimeChanged: (DateTime newTime) {
                                  setState(() {
                                    dataIni = newTime;
                                  });
                                },
                                use24hFormat: true,
                                mode: CupertinoDatePickerMode.dateAndTime,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Data Inicial: ${dataIni.toString().substring(0, dataIni.toString().indexOf(' '))}  ${dataIni.toString().substring(dataIni.toString().indexOf(' '), dataIni.toString().indexOf(' ') + 6)}',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                      child: TextButton(
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: CupertinoDatePicker(
                                backgroundColor: Colors.white,
                                initialDateTime: dataFi,
                                onDateTimeChanged: (DateTime newTime) {
                                  setState(() {
                                    dataFi = newTime;
                                  });
                                },
                                use24hFormat: true,
                                mode: CupertinoDatePickerMode.dateAndTime,
                              ),
                            ),
                          );
                        },
                        child: Text(
                            'Data Final: ${dataFi.toString().substring(0, dataFi.toString().indexOf(' '))}  ${dataFi.toString().substring(dataFi.toString().indexOf(' '), dataFi.toString().indexOf(' ') + 6)}',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black)),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: scheduleController,
                  decoration: const InputDecoration(
                      labelText: 'Informació horària',
                      labelStyle: TextStyle(fontSize: 12)),
                ),
                TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(
                      labelText: 'Ciutat', labelStyle: TextStyle(fontSize: 12)),
                ),
                TextFormField(
                  controller: postalCodeController,
                  decoration: const InputDecoration(
                      labelText: 'Codi Postal',
                      labelStyle: TextStyle(fontSize: 12)),
                ),
                TextFormField(
                  controller: addressController,
                  enableSuggestions: true,
                  decoration: const InputDecoration(
                      labelText: 'Adreça',
                      labelStyle: TextStyle(fontSize: 12),
                      hintText: 'Format: Carrer, Número',
                      hintStyle: TextStyle(fontSize: 12)),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  children: [
                  Text('Imatge de l\'event: '),
                  Container(
                    height: MediaQuery.of(context).size.height*0.036,
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                      ),
                    child: TextButton(onPressed: () async {
                      await selectImage();
                    }, child: Text('Puja una imatge', style: TextStyle(color: Colors.white),)))
                ]),
              ],
            ),
          )),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel·lar'),
            ),
            TextButton(
              onPressed: () async {
                EventsController.enviarFormulari(nameController.text, dataIni.toString(), dataFi.toString(), denominationController.text, descriptionController.text, ticketsController.text, scheduleController.text, [], addressController.text, postalCodeController.text, emailController.text, cityController.text, urlController.text,imageEvent );
              },
              child: Text('Enviar Sol·licitud'),
            ),
          ],
        ),
      ],
    );
  }
}
