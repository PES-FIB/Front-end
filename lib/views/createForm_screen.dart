import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prova_login/controllers/eventsController.dart';
import 'package:prova_login/controllers/taskController.dart';
import 'package:prova_login/controllers/userController.dart';
import 'styles/custom_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import '../models/AppEvents.dart';

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
  TextEditingController imageController = TextEditingController();
  List<String> selectedValues = [];
  late DateTime dataIni = DateTime.now();
  late DateTime dataFi = DateTime.now();
  bool mostrarpicklist = false;

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
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          mostrarpicklist = !mostrarpicklist;
                        });
                      },
                      child: Text('Seleccionar Àmbits... ▼'),
                    ),
                  ],
                ),
                mostrarpicklist?
                Column(
                  children: AppEvents.ambits.map((String ambit) {
                    return CheckboxListTile(
                      title: Text(ambit),
                      value: selectedValues.contains(ambit),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            selectedValues.add(ambit);
                          } else {
                            selectedValues.remove(ambit);
                          }
                          print('selectedValues: $selectedValues');
                        });
                      },
                    );
                  }).toList(),
                ): SizedBox(height: 0),
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
                  decoration: const InputDecoration(
                      labelText: 'Adreça',
                      labelStyle: TextStyle(fontSize: 12),
                      hintText: 'Format: Carrer, Número',
                      hintStyle: TextStyle(fontSize: 12)),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                TextFormField(
                  controller: imageController,
                  decoration: const InputDecoration(
                      labelText: 'Imatge',
                      labelStyle: TextStyle(fontSize: 12),
                      hintText:
                          'Enllaç de la imatge, en format PNG o JPG, ha de ser una URL vàlida i pública',
                      hintStyle: TextStyle(fontSize: 12)),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                int returnvalue = await EventsController.enviarFormulari(
                    nameController.text,
                    dataIni.toString(),
                    dataFi.toString(),
                    denominationController.text,
                    descriptionController.text,
                    ticketsController.text,
                    scheduleController.text,
                    [],
                    addressController.text,
                    postalCodeController.text,
                    emailController.text,
                    cityController.text,
                    urlController.text,
                    imageController.text);
                if (returnvalue == 1) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sol·licitud enviada!')));
                } else if (returnvalue == -4) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'No s\ha trobat l\'adreça, si us plau, introdueix una adreça vàlida')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Hi ha hagut un error en la sol·licitud. Si us plau, revisi les dades introduïdes')));
                }
              },
              child: Text('Enviar Sol·licitud'),
            ),
          ],
        ),
      ],
    );
  }
}
