import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:prova_login/views/EventList.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/Event.dart';
import 'event_screen.dart';
import '../controllers/eventsController.dart';
import '../models/Event.dart';
import '../models/AppEvents.dart';

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
  //Map<String, Event> mapSavedEvents = {};
  List<Event> savedEventsList = [];

  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime _focusedDay) {
    setState(() {
      today = day;
      if (AppEvents.savedEventsCalendar.containsKey(DateUtils.dateOnly(today))) {
      savedEventsList = AppEvents.savedEventsCalendar[DateUtils.dateOnly(today)]!;
      print('tamany de la llista = ${savedEventsList.length}');
      }
      else  {
        savedEventsList = [];
      }
      // update `_focusedDay` here as well
    });
  }

  Future<Map<dynamic, dynamic>> loadSavedEvents() async {
    return await EventsController.getSavedEvents();
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
    if (AppEvents.savedEventsCalendar.containsKey(DateUtils.dateOnly(today))) {
      savedEventsList = AppEvents.savedEventsCalendar[DateUtils.dateOnly(today)]!;
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
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text("Els teus events preferits!"),
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
              selectedDayPredicate: (day) =>isSameDay(day, today),
              onDaySelected: _onDaySelected,
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                    color: Colors.redAccent, shape: BoxShape.circle,),
                todayDecoration: BoxDecoration(
                    color: Colors.blueGrey, shape: BoxShape.circle),
                todayTextStyle: TextStyle(color: Colors.white, fontSize: 16)
              ),
              
              calendarBuilders: CalendarBuilders(
                markerBuilder:(context, day, focusedDay) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 30), 
                      child: Align (
                      alignment: Alignment.center,
                      child: AppEvents.savedEventsCalendar.containsKey(DateUtils.dateOnly(day)) && AppEvents.savedEventsCalendar[DateUtils.dateOnly(day)]!= null?
                      Icon(Icons.circle, color: Colors.black, size: 8):
                      SizedBox(height: 0,width: 0,)
                      ),
                    );
                  },
                  ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: savedEventsList.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    tileColor: Colors.redAccent,
                      key: ValueKey(savedEventsList[index].code),
                      contentPadding: EdgeInsets.all(20.0),
                      title: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(savedEventsList[index].title, style: TextStyle(color: Colors.white, fontSize: 20)),
                            SizedBox(height: 5),
                            Text(savedEventsList[index].city,style:TextStyle(color: Colors.white, fontSize: 15)),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                savedEventsList[index].initialDate != savedEventsList[index].finalDate?
                                Row (
                                  children: [
                                Text(savedEventsList[index].initialDate.substring(0,10), style:TextStyle(color: Colors.white, fontSize: 15)),
                                Text(' - ', style:TextStyle(color: Colors.white, fontSize: 15)),
                                Text(savedEventsList[index].finalDate.substring(0,10), style:TextStyle(color: Colors.white, fontSize: 15)),
                                ]
                                ):
                                Text(savedEventsList[index].initialDate.substring(0,10), style:TextStyle(color: Colors.white, fontSize: 15)),
            
                              ],
                            )
                          ],
                        ),
                      ),
                      leading: Icon(Icons.event, color: Colors.white, size: 30),
                      trailing: IconButton(
                        iconSize: 25,
                        icon: Icon(Icons.favorite, color: Colors.white),
                        onPressed: () async{
                          print('codi a borrar = ${savedEventsList[index].code}');
                          EventsController controller =
                                EventsController(context);
                           controller.unsaveEvent(savedEventsList[index].code);
                          setState(() {
                            print('valor del map ${AppEvents.savedEvents[savedEventsList[index].code]}');
                             AppEvents.savedEventsCalendar[DateUtils.dateOnly(today)]?.remove(savedEventsList[index]);
                             if (AppEvents.savedEvents.containsKey(savedEventsList[index].code)) {
                              AppEvents.savedEvents.remove(savedEventsList[index].code);
                             }
                            savedEventsList.remove(savedEventsList[index]);
                             //print('saved event list dia 8 = ${savedEventsList[index].code}');
                            //savedEventsList.remove(savedEventsList[index]);
                          });
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
