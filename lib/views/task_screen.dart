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
  bool eliminar = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.t.name);
    descriptionController = TextEditingController(text:widget.t.description);
    if (widget.t.repeats == '' ){
      repeteix = 'NO';
    }
    else {
repeteix = widget.t.repeats;
    }
    task_ini = DateTime.parse(widget.t.initial_date);
    task_fi = DateTime.parse(widget.t.final_date);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.greenAccent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [ 
          SizedBox (
          width: MediaQuery.of(context).size.width*0.3,
          child:Text('#${widget.t.name}',maxLines: 3,)
        ),        
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton (icon: !edit? Icon(Icons.edit):Icon(LineAwesomeIcons.times),
            onPressed:  (){
              setState(() {
                edit = !edit;
              });
            }),
            IconButton (icon:Icon(Icons.delete),
          onPressed:  (){
          setState(() {
            eliminar = true;
          });
        }),
          ],
        ),
        ]),
      content: 
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.5,
        child:
        !eliminar? 
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFormField(
              enabled: edit,
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: 'Nom', labelStyle: TextStyle(fontSize: 12)),
            ),
            TextFormField(
              enabled: edit,
              maxLines: 3,
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
                      'Data Inicial: ${task_ini.toString().substring(0, task_ini.toString().indexOf(' '))}  ${task_ini.toString().substring(task_ini.toString().indexOf(' '), task_ini.toString().indexOf(' ')+6)}',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                )
              ],
            ): Row(children: [Text('Data Inicial: ${task_ini.toString().substring(0, task_ini.toString().indexOf(' '))}  ${task_ini.toString().substring(task_ini.toString().indexOf(' '), task_ini.toString().indexOf(' ')+6)}', style: TextStyle(fontSize: 15, color: Colors.black))]),
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
                        'Data Final: ${task_fi.toString().substring(0, task_fi.toString().indexOf(' '))}  ${task_fi.toString().substring(task_fi.toString().indexOf(' '), task_fi.toString().indexOf(' ')+6)}',
                        style: TextStyle(fontSize: 15, color: Colors.black)),
                  ),
                ),
              ],
            ): Row(
              children: [
                Text('Data Final: ${task_fi.toString().substring(0, task_fi.toString().indexOf(' '))}  ${task_fi.toString().substring(task_fi.toString().indexOf(' '), task_fi.toString().indexOf(' ')+6)}',style: TextStyle(fontSize: 15, color: Colors.black)),
              ],
            ),
            edit?
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Es repeteix?    ', style: TextStyle(fontSize: 16),),
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
            Row(
              children: [
                Text('Es repeteix?  NO'),
              ],
            ): Row(
              children: [
                Text('Es repeteix?  ${widget.t.repeats}'),
              ],
            )
          ],
        ):SizedBox(
          child: Column(children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.1),
            Text('Està segur que vol eliminar la tasca?', textAlign: TextAlign.center,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: (){}, child: Text('SI', style: TextStyle(color: Colors.black, fontSize: 15))),
                TextButton(
                  onPressed: (){
                    setState(() {
                      eliminar = false;
                    });
                  }, 
                  child: Text('NO', style: TextStyle(color: Colors.black, fontSize: 15)))
              ],
            ),

          ]),
        )
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        TextButton(
          onPressed: () async{
            if (task_ini != DateTime.parse(widget.t.initial_date) || task_fi != DateTime.parse(widget.t.final_date) || nameController.text != widget.t.name || descriptionController.text != widget.t.description || (repeteix != widget.t.repeats && repeteix != 'NO' && widget.t.repeats != '')) {
              if (task_ini.isAfter(task_fi)) {
                ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'La data inicial no pot ser major a la final'));
              }
              else if (nameController.text.isEmpty) {
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
          child: Text('Save', style: TextStyle(color: Colors.black),),
        ),
      ],
    );
  }
}