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
import '../models/Event.dart';
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

  void _onDaySelected(DateTime day, DateTime _focusedDay) {
    setState(() {
      today = day;
      if (AppEvents.savedEventsCalendar.value
          .containsKey(DateUtils.dateOnly(today))) {
        savedEventsList =
            AppEvents.savedEventsCalendar.value[DateUtils.dateOnly(today)]!;
        listSize = savedEventsList.length;
        print('tamany de la llista = ${savedEventsList.length}');
      } else {
        savedEventsList = [];
        listSize = 0;
      }
      // update `_focusedDay` here as well
    });
  }

/*
void initEvents() {
  loadSavedEvents().then((value){
       setState(() {
        savedEventsCalendar.addAll(value.values.toList());
      });
    });
}
*/

  @override
  void initState() {
    super.initState();
    print('LLista inicial, map = ${AppEvents.savedEventsCalendar}');
    if (AppEvents.savedEventsCalendar.value
        .containsKey(DateUtils.dateOnly(today))) {
      savedEventsList =
          AppEvents.savedEventsCalendar.value[DateUtils.dateOnly(today)]!;
      listSize = savedEventsList.length;
    }
    print('tamany de la llista = ${savedEventsList.length}');
    AppEvents.savedEventsCalendar.addListener(() {
      setState(() {});
    });
    AppEvents.savedEvents.addListener(() {
      setState(() {});
    });
    AppEvents.eventsList.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    AppEvents.savedEventsCalendar.removeListener(() {
      setState(() {});
    });
    AppEvents.savedEvents.removeListener(() {
      setState(() {});
    });
    AppEvents.eventsList.removeListener(() {
      setState(() {});
    });
    super.dispose();
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
            Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  statusDownload == 0
                      ? IconButton(
                            iconSize: 37,
                            icon: Icon(Icons.download_for_offline_rounded,
                                color: Colors.redAccent),
                            onPressed: () async {
                              // int downloadResult = await userController.exportCalendar('${User.name.substring(0,User.name.indexOf(' '))}EventCal.ics');
                              // if (downloadResult  == -1) {
                              //   ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'Hi ha hagut un error a la Descàrrega'));
                              // }
                              // else if (downloadResult == -2) {
                              //   ScaffoldMessenger.of(context).showSnackBar(customSnackbar(context, 'No es pot realitzar la descàrrega sense permisos'));
                              // }
                              // else {}
                              setState(() {
                                statusDownload = 1;
                              });
                              Future.delayed(Duration(seconds: 2), () {
                                setState(() {
                                  statusDownload = 2;
                                  Future.delayed(Duration(seconds: 2), () {
                                    setState(() {
                                      statusDownload = 0;
                                    });
                                  });
                                });
                              });
                            },
                          )
                      : statusDownload == 1
                          ? SpinKitFadingCircle(
                                color: Colors.redAccent,
                              )
                          : Padding(padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.02, top:MediaQuery.of(context).size.width*0.02),
                          child:Icon(Icons.check_circle,
                                  color: Colors.redAccent, size: 37)),
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
                        child: AppEvents.savedEventsCalendar.value
                                    .containsKey(DateUtils.dateOnly(day)) &&
                                AppEvents.savedEventsCalendar
                                        .value[DateUtils.dateOnly(day)] !=
                                    null
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
                itemCount: listSize,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                      tileColor: Colors.redAccent,
                      contentPadding: EdgeInsets.all(20.0),
                      title: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(savedEventsList[index].title,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            SizedBox(height: 5),
                            Text(savedEventsList[index].city,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
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
                      ),
                      leading: Icon(Icons.event, color: Colors.white, size: 30),
                      trailing: IconButton(
                        iconSize: 25,
                        icon: Icon(Icons.favorite, color: Colors.white),
                        onPressed: () async {
                          print(
                              'codi a borrar = ${savedEventsList[index].code}');
                          print(
                              'savedeventslist length abans = ${savedEventsList.length}');
                          setState(() {
                            print(
                                'valor del map ${AppEvents.savedEvents.value[savedEventsList[index].code]}');
                            AppEvents.savedEventsCalendar
                                .value[DateUtils.dateOnly(today)]
                                ?.remove(savedEventsList[index]);
                            //  print('savedeventslist length = ${savedEventsList.length}');
                            //  if (AppEvents.savedEvents.value.containsKey(savedEventsList[index].code)) {
                            //   AppEvents.savedEvents.value.remove(savedEventsList[index].code);
                            // }
                            savedEventsList.remove(savedEventsList[index]);
                            //print('saved event list dia 8 = ${savedEventsList[index].code}');
                            //savedEventsList.remove(savedEventsList[index]);
                          });
                          EventsController controller =
                              EventsController(context);
                          controller.unsaveEvent(savedEventsList[index].code);
                        },
                      ),
                      onTap: () {
                        pushEventScreen(index);
                      }),
                ),
              ),
            ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: savedEventsList.length,
            //     itemBuilder: (context, index) => Card(
            //       child: ListTile(
            //           key: ValueKey(savedEventsList[index].title),
            //           contentPadding: EdgeInsets.all(20.0),
            //           title: Text(savedEventsList[index].title),
            //           leading:
            //               Icon(Icons.event, color: Colors.black, size: 30),
            //           trailing: IconButton(
            //             iconSize: 25,
            //             icon: Icon(Icons.favorite,
            //                 color: Colors.redAccent),
            //             onPressed: () {
            //               setState(() {
            //                 widget.savedEventsMap.remove(savedEventsList[index].code);
            //                 EventsController controller = EventsController(context);
            //                 controller.unsaveEvent(savedEventsList[index].code);
            //               });
            //               loadSavedEvents().then((value){
            //                 savedEventsList.clear();
            //                 setState(() {
            //                   savedEventsList.addAll(value.values.toList());
            //                 });
            //               });
            //             },
            //           ),
            //           onTap: () {
            //             pushEventScreen(index);
            //           }),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
