import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:prova_login/controllers/taskController.dart';
import 'styles/custom_snackbar.dart';
import 'package:prova_login/views/EventList.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/Event.dart';
import '../models/User.dart';
import 'event_screen.dart';
import '../controllers/eventsController.dart';
import '../controllers/userController.dart';
import '../models/AppEvents.dart';
import '../models/Task.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class taskScreen extends StatefulWidget {
  const taskScreen({super.key, required this.t});
  final Task t;
  @override
  _taskScreenState createState() => _taskScreenState();
}

class _taskScreenState extends State<taskScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late DateTime task_ini;
  late DateTime task_fi;
  String? repeteix;
  bool edit = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.t.name);
    descriptionController = TextEditingController(text:widget.t.description);
    repeteix = widget.t.repeats;
    task_ini = DateTime.parse(widget.t.initial_date);
    task_ini = DateTime.parse(widget.t.final_date);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [ 
        Center (
        child:Text('Editar Tasca')
        ),
        IconButton (icon: Icon(Icons.edit),
        onPressed:  (){
          setState(() {
            edit = true;
          });
        })
        ]),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              enabled: edit,
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: 'Nom', labelStyle: TextStyle(fontSize: 12)),
            ),
            TextFormField(
              enabled: edit,
              controller: descriptionController,
              decoration: const InputDecoration(
                  labelText: 'Descripció', labelStyle: TextStyle(fontSize: 12)),
            ),
            edit?
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
                            initialDateTime: DateTime.now(),
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                task_ini = newTime;
                              });
                            },
                            use24hFormat: true,
                            mode: CupertinoDatePickerMode.dateAndTime,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Data Inicial: ${task_ini.toString().substring(0, task_ini.toString().indexOf(' '))}',
                      style: TextStyle(fontSize: 13.5, color: Colors.black),
                    ),
                  ),
                )
              ],
            ): Text(widget.t.initial_date),
            edit?
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
                            initialDateTime: DateTime.now(),
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                task_fi = newTime;
                              });
                            },
                            use24hFormat: true,
                            mode: CupertinoDatePickerMode.dateAndTime,
                          ),
                        ),
                      );
                    },
                    child: Text(
                        'Data Final: ${task_fi.toString().substring(0, task_fi.toString().indexOf(' '))}',
                        style: TextStyle(fontSize: 13.5, color: Colors.black)),
                  ),
                ),
              ],
            ): Text(widget.t.final_date),
            edit?
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Es repeteix?    ', style: TextStyle(fontSize: 14),),
                DropdownButton<String>(
                  value: repeteix,
                  onChanged: (String? newValue) {
                    setState(() {
                      repeteix = newValue;
                    });
                  },
                  items: <String>['NO', 'daily', 'weekly', 'monthly', 'yearly']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            ): widget.t.repeats == ''?
            Text('NO'):Text(widget.t.repeats)
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async{
            if (task_ini.toString() != widget.t.initial_date || task_fi.toString() != widget.t.final_date || nameController.text != widget.t.name || descriptionController.text != widget.t.description || repeteix != widget.t.repeats) {
              if (task_ini.isAfter(task_fi)) {
                ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'La data inicial no pot ser major a la final'));
              }
              else if (nameController.text == null || nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'Indiqui el nom de la tasca'));
              }
              else {
              int result = await taskController.updateTask(widget.t, widget.t.id, nameController.text, descriptionController.text, task_ini.toString(), task_fi.toString(), repeteix);
                if (result == -1) {
                  ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'Hi ha hagut un error en la edició de la tasca'));
                }
                else {
                  print('longitud de tasks = ${AppEvents.tasksCalendar.length}');
                  Navigator.of(context).pop();
                }
              }
            }
            else {
              ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'No es pot guardar sense canviar valors'));
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}