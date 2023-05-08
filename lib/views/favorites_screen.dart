import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:prova_login/controllers/taskController.dart';
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
import 'styles/custom_snackbar.dart';

class Favorites extends StatefulWidget {
  //final VoidCallback onNavigate;

  const Favorites({
    Key? key,
    //required this.onNavigate,
  }) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  //Map<String, Event> mapSavedEvents = {};
  List<Event> savedEventsList = [];
  int listSize = 0;
  int statusDownload = 0;
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      print(
          'ho conte?? -> ${AppEvents.savedEventsCalendar.containsKey(DateUtils.dateOnly(today))}');
      if (AppEvents.savedEventsCalendar
          .containsKey(DateUtils.dateOnly(today))) {
        savedEventsList =
            AppEvents.savedEventsCalendar[DateUtils.dateOnly(today)]!;
        print('tamany de la llista = ${savedEventsList.length}');
      } else {
        savedEventsList = [];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print('LLista inicial, map = ${AppEvents.savedEventsCalendar}');
    if (AppEvents.savedEventsCalendar.containsKey(DateUtils.dateOnly(today))) {
      savedEventsList =
          AppEvents.savedEventsCalendar[DateUtils.dateOnly(today)]!;
      listSize = savedEventsList.length;
    }
    print('tamany de la llista = ${savedEventsList.length}');
  }

  void pushEventScreen(int clickedEvent) async {
    final updatedEvent = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Events(event: savedEventsList[clickedEvent])));
    if (updatedEvent != null) {
      setState(() {
        savedEventsList[clickedEvent] =
            updatedEvent; //for favourite coherence between views.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(children: [
              Container(
                  height: 30,
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05),
                  width: MediaQuery.of(context).size.width,
                  child: Text('EL TEU CALENDARI',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20))),
            ]),
            Container(
              height: 3,
              width: MediaQuery.of(context).size.width * 0.92,
              decoration: BoxDecoration(color: Colors.redAccent),
            ),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01),
                      child: TextButton(
                          onPressed: () {
                            _onDaySelected(DateTime.now(), DateTime.now());
                          },
                          child: Text('Avui'))),
                  Row(
                    children: [
                      statusDownload == 0
                          ? IconButton(
                              iconSize: 30,
                              icon: Icon(LineAwesomeIcons.download,
                                  color: Colors.redAccent),
                              onPressed: () async {
                                print(
                                    'nom = ${User.name.substring(0, User.name.indexOf(' '))}');
                                int downloadResult =
                                    await userController.exportCalendar(
                                        '${User.name.substring(0, User.name.indexOf(' '))}EventCal.ics');
                                setState(() {
                                  statusDownload = 1;
                                });
                                if (downloadResult == -1) {
                                  setState(() {
                                    statusDownload = 0;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      customSnackbar(context,
                                          'Hi ha hagut un error a la Descàrrega'));
                                } else if (downloadResult == -2) {
                                  setState(() {
                                    statusDownload = 0;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      customSnackbar(context,
                                          'No es pot realitzar la descàrrega sense permisos'));
                                } else {
                                  setState(() {
                                    statusDownload = 2;
                                    Future.delayed(Duration(seconds: 2), () {
                                      setState(() {
                                        statusDownload = 0;
                                      });
                                    });
                                  });
                                }
                              },
                            )
                          : statusDownload == 1
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.01,
                                      right: MediaQuery.of(context).size.width *
                                          0.02),
                                  child: SpinKitFadingCircle(
                                    size: 30,
                                    color: Colors.redAccent,
                                  ))
                              : Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.02,
                                      top: MediaQuery.of(context).size.width *
                                          0.02),
                                  child: Icon(Icons.check_circle,
                                      color: Colors.redAccent, size: 37)),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return MyAlertDialog();
                                });
                          },
                          iconSize: 30,
                          icon: Icon(LineAwesomeIcons.plus_circle,
                              color: Colors.redAccent))
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TableCalendar(
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  availableGestures: AvailableGestures.all,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  focusedDay: today,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  selectedDayPredicate: (day) => isSameDay(day, today),
                  onDaySelected: _onDaySelected,
                  calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                          color: Colors.blueGrey, shape: BoxShape.circle),
                      todayTextStyle:
                          TextStyle(color: Colors.white, fontSize: 16)),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, focusedDay) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Align(
                            alignment: Alignment.center,
                            child: AppEvents.savedEventsCalendar
                                        .containsKey(DateUtils.dateOnly(day)) &&
                                    AppEvents.savedEventsCalendar[
                                            DateUtils.dateOnly(day)] !=
                                        null &&
                                    AppEvents
                                            .savedEventsCalendar[
                                                DateUtils.dateOnly(day)]
                                            ?.length !=
                                        0
                                ? Icon(Icons.circle,
                                    color: Colors.black, size: 8)
                                : SizedBox(
                                    height: 0,
                                    width: 0,
                                  )),
                      );
                    },
                  ),
                )),
            Expanded(
              child: ListView.builder(
                key: _listKey,
                itemCount: savedEventsList.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                      tileColor: Colors.redAccent,
                      contentPadding: EdgeInsets.all(20.0),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(savedEventsList[index].title,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          SizedBox(height: 5),
                          Text(savedEventsList[index].city,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              savedEventsList[index].initialDate !=
                                      savedEventsList[index].finalDate
                                  ? Row(children: [
                                      Text(
                                          savedEventsList[index]
                                              .initialDate
                                              .substring(0, 10),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15)),
                                      Text(' - ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15)),
                                      Text(
                                          savedEventsList[index]
                                              .finalDate
                                              .substring(0, 10),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15)),
                                    ])
                                  : Text(
                                      savedEventsList[index]
                                          .initialDate
                                          .substring(0, 10),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                            ],
                          )
                        ],
                      ),
                      leading: Icon(Icons.event, color: Colors.white, size: 30),
                      trailing: IconButton(
                        iconSize: 25,
                        icon: Icon(Icons.favorite, color: Colors.white),
                        onPressed: () async {
                          EventsController.unsaveEvent(
                              savedEventsList[index].code);
                          setState(() {
                            EventsController.unsaveEventLocale(
                                savedEventsList[index]);
                          });
                        },
                      ),
                      onTap: () {
                        pushEventScreen(index);
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyAlertDialog extends StatefulWidget {
  @override
  _MyAlertDialogState createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime task_ini = DateTime.now();
  DateTime task_fi = DateTime.now();
  String? repeteix = 'NO';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Nova Tasca')),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
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
                  items: <String>['NO', 'daily', 'weekly', 'monthly', 'yearly']
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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Task t = Task('', nameController.text, descriptionController.text, task_ini.toString(), task_fi.toString(), repeteix!);
            taskController.addTaskLocale(t);
            Navigator.of(context).pop();
            setState(() {
            });
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
