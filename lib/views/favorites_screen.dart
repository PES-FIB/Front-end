import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:prova_login/views/EventList.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/Event.dart';
import '../models/User.dart';
import 'event_screen.dart';
import '../controllers/eventsController.dart';
import '../controllers/userController.dart';
import '../models/AppEvents.dart';
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
                              ? Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.01,right: MediaQuery.of(context).size.width*0.02),child:SpinKitFadingCircle(
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
                          onPressed: () {},
                          iconSize: 30,
                          icon: Icon(LineAwesomeIcons.plus_circle,
                              color: Colors.redAccent))
                    ],
                  )
                ],
              ),
            ),
            TableCalendar(
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              availableGestures: AvailableGestures.all,
              startingDayOfWeek: StartingDayOfWeek.monday,
              focusedDay: today,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              rowHeight: MediaQuery.of(context).size.width * 0.13,
              selectedDayPredicate: (day) => isSameDay(day, today),
              onDaySelected: _onDaySelected,
              calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                      color: Colors.blueGrey, shape: BoxShape.circle),
                  todayTextStyle: TextStyle(color: Colors.white, fontSize: 16)),
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
                            ? Icon(Icons.circle, color: Colors.black, size: 8)
                            : SizedBox(
                                height: 0,
                                width: 0,
                              )),
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.02),
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
