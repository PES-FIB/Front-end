import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../views/createTask_screen.dart';
import '../views/task_screen.dart';
import 'styles/custom_snackbar.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/Event.dart';
import '../models/User.dart';
import 'event_screen.dart';
import '../controllers/eventsController.dart';
import '../controllers/userController.dart';
import '../models/AppEvents.dart';
import '../models/Task.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  final GlobalKey<AnimatedListState> _listkey2 = GlobalKey();
  //Map<String, Event> mapSavedEvents = {};
  List<Event> savedEventsList = [];
  List<Task> savedTasksList = [];
  int statusDownload = 0;
  DateTime today = DateTime.now();

  Future<void> _showDialogAndThenUpdateState(BuildContext context) async {
  // Show a dialog and wait for it to be popped
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return createTask(selectedDate: today);
    },
  );
  setState(() {
    _onDaySelected(today, today);
  });
}

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      if (AppEvents.savedEventsCalendar
          .containsKey(DateUtils.dateOnly(today))) {
        savedEventsList =
            AppEvents.savedEventsCalendar[DateUtils.dateOnly(today)]!;
      } else {
        savedEventsList = [];
      }
      if (AppEvents.tasksCalendar
          .containsKey(DateUtils.dateOnly(today))) {
        savedTasksList =
            AppEvents.tasksCalendar[DateUtils.dateOnly(today)]!;
      } else {
        savedTasksList = [];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (AppEvents.savedEventsCalendar.containsKey(DateUtils.dateOnly(today))) {
      savedEventsList =
          AppEvents.savedEventsCalendar[DateUtils.dateOnly(today)]!;
    }
    if (AppEvents.tasksCalendar.containsKey(DateUtils.dateOnly(today))) {
      savedTasksList =
          AppEvents.tasksCalendar[DateUtils.dateOnly(today)]!;
    }
  }


  void pushEventScreen(int clickedEvent) async {
    final updatedEvent = await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Events(event: savedEventsList[clickedEvent]),
          );
        },
      );
    if (updatedEvent != null) {
      setState(() {
        savedEventsList[clickedEvent] =
            updatedEvent; //for favourite coherence between views.
      });
    }
  }

  void pushTaskScreen(int clickedTask) async {
    await showDialog(
    context: context,
    builder: (BuildContext context) {
      return taskScreen(t: savedTasksList[clickedTask]);
    },
  );
   setState(() {
    _onDaySelected(today, today);
  });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
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
                                int downloadResult =
                                    await UserController.exportCalendar(
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
                            _showDialogAndThenUpdateState(context);
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
                        shape: BoxShape.circle,
                        border: Border.all(color:Colors.black, width: 1.0)
                      ),
                      selectedTextStyle: TextStyle(color: Colors.black),
                      todayDecoration: BoxDecoration(
                          color: Color.fromARGB(255, 70, 70, 70), shape: BoxShape.circle),
                      todayTextStyle:
                          TextStyle(color: Colors.white, fontSize: 16)),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, focusedDay) {
                      return Padding(
                        padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.03),
                        child: Align(
                          alignment: Alignment.center,
                          child: (AppEvents.savedEventsCalendar.containsKey(DateUtils.dateOnly(day)) &&AppEvents.savedEventsCalendar[DateUtils.dateOnly(day)] !=null 
                          && AppEvents.savedEventsCalendar[DateUtils.dateOnly(day)]?.length != 0) && (AppEvents.tasksCalendar.containsKey(DateUtils.dateOnly(day)) &&AppEvents.tasksCalendar[DateUtils.dateOnly(day)] !=null 
                          && AppEvents.tasksCalendar[DateUtils.dateOnly(day)]?.length != 0) ? 
                          Icon(Icons.circle,color: Colors.black, size: 8)
                          : AppEvents.savedEventsCalendar.containsKey(DateUtils.dateOnly(day)) &&AppEvents.savedEventsCalendar[DateUtils.dateOnly(day)] !=null 
                          && AppEvents.savedEventsCalendar[DateUtils.dateOnly(day)]?.length != 0?
                          Icon(Icons.circle,color: Colors.red, size: 8)
                          :AppEvents.tasksCalendar.containsKey(DateUtils.dateOnly(day)) &&AppEvents.tasksCalendar[DateUtils.dateOnly(day)] !=null 
                          && AppEvents.tasksCalendar[DateUtils.dateOnly(day)]?.length != 0?
                          Icon(Icons.circle,color: Color.fromARGB(255, 118, 184, 121), size: 8)
                          :SizedBox(
                            height: 0,
                            width: 0,
                          )
                        ),
                      );
                    },
                  ),
                )),
            savedEventsList.isNotEmpty?
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
            ):SizedBox(height:0),
            savedTasksList.isNotEmpty?
            Expanded(
              child: ListView.builder(
                key: _listkey2,
                itemCount: savedTasksList.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                      tileColor: Color.fromARGB(255, 0, 114, 59),
                      contentPadding: EdgeInsets.all(20.0),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(savedTasksList[index].name,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              savedTasksList[index].initial_date !=
                                      savedTasksList[index].final_date
                                  ? Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${savedTasksList[index]
                                              .initial_date
                                              .substring(0, 10)} ${savedTasksList[index]
                                              .initial_date
                                              .substring(11, 16)} - \n${savedTasksList[index]
                                              .final_date
                                              .substring(0, 10)} ${savedTasksList[index]
                                              .final_date
                                              .substring(11, 16)}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15)),
                                        ])
                                  : Text(
                                      '${savedTasksList[index]
                                              .initial_date
                                              .substring(0, 10)} ${savedTasksList[index]
                                              .initial_date
                                              .substring(11, 16)}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                            ],
                          )
                        ],
                      ),
                      leading: Icon(Icons.task_alt_sharp, color: Colors.white, size: 30),
                      onTap: () {
                        pushTaskScreen(index);
                      },
                      ),
                ),
              ),
            ):SizedBox(height:0)
          ],
        ),
      ),
    );
  }
}


