import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/Event.dart';
import 'event_screen.dart';
import '../controllers/eventsController.dart';
import '../models/Event.dart';

class Favorites extends StatefulWidget {
  final Map<dynamic, dynamic> savedEvents;
  //final VoidCallback onNavigate;

  const Favorites({
    Key? key,
    required this.savedEvents,
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
      if (widget.savedEvents.containsKey(DateUtils.dateOnly(today))) {
      savedEventsList = widget.savedEvents[DateUtils.dateOnly(today)];
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
        savedEvents.addAll(value.values.toList());
      });
    });
}
*/

  @override
  void initState() {
    super.initState();
    print('LLista inicial, map = ${widget.savedEvents}');
    if (widget.savedEvents.containsKey(DateUtils.dateOnly(today))) {
      savedEventsList = widget.savedEvents[DateUtils.dateOnly(today)];
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
                    color: Colors.redAccent, shape: BoxShape.circle),
                todayDecoration: BoxDecoration(
                    color: Colors.blueGrey, shape: BoxShape.circle),
                todayTextStyle: TextStyle(color: Colors.white, fontSize: 16)
              ),
              
              calendarBuilders: CalendarBuilders(
                markerBuilder:(context, day, focusedDay) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: savedEventsList.isNotEmpty?
                      Text(savedEventsList.length.toString()):
                      SizedBox(height: 0,width: 0,)
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
                      key: ValueKey(savedEventsList[index].title),
                      contentPadding: EdgeInsets.all(20.0),
                      title: Text(savedEventsList[index].title),
                      leading: Icon(Icons.event, color: Colors.black, size: 30),
                      trailing: IconButton(
                        iconSize: 25,
                        icon: Icon(Icons.favorite, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            widget.savedEvents[DateUtils.dateOnly(today)]
                                .remove(savedEventsList[index]);
                            EventsController controller =
                                EventsController(context);
                            controller.unsaveEvent(savedEventsList[index].code);
                          });
                          loadSavedEvents().then((value) {
                            setState(() {
                            });
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
            //                 widget.savedEvents.remove(savedEventsList[index].code);
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
