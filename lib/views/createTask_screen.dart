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

class createTask extends StatefulWidget {
  const createTask({super.key, required this.selectedDate});
  final DateTime selectedDate;
  @override
  _createTaskState createState() => _createTaskState();
}

class _createTaskState extends State<createTask> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late DateTime task_ini;
  late DateTime task_fi;
  String? repeteix = 'NO';

  @override
  void initState() {
    super.initState();
    task_ini = widget.selectedDate;
    task_fi = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Nova Tasca')),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: 'Nom', labelStyle: TextStyle(fontSize: 12)),
            ),
            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: 'Descripció', labelStyle: TextStyle(fontSize: 12)),
            ),
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
                            initialDateTime: task_ini,
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
                      'Data Inicial: ${task_ini.toString().substring(0, task_ini.toString().indexOf(' '))}  ${task_ini.toString().substring(task_ini.toString().indexOf(' '), task_ini.toString().indexOf(' ')+6)}',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
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
                            initialDateTime: task_fi,
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
                        'Data Final: ${task_fi.toString().substring(0, task_fi.toString().indexOf(' '))}  ${task_fi.toString().substring(task_fi.toString().indexOf(' '), task_fi.toString().indexOf(' ')+6)}',
                        style: TextStyle(fontSize: 15, color: Colors.black)),
                  ),
                ),
              ],
            ),
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
                  items: <String>['NO', 'Diàriament', 'Setmanalment', 'Mensualment', 'Anualment']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            )
          ],
        ),
      ),
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
              onPressed: () async{
                if (task_ini.isAfter(task_fi)) {
                  ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'La data inicial no pot ser major a la final'));
                }
                else if (nameController.text == null || nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'Indiqui el nom de la tasca'));
                }
                else {
                int result = await taskController.createTask(nameController.text, descriptionController.text, task_ini.toString(), task_fi.toString(), repeteix);
                  if (result == -1) {
                    ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'Hi ha hagut un error en la creació de la tasca'));
                  }
                  else {
                    print('longitud de tasks = ${AppEvents.tasksCalendar.length}');
                    Navigator.of(context).pop();
                  }
                }
              },
          child: Text('Crear'),
          ),
        ],
        ),
      ],
    );
  }
}