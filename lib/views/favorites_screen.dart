import 'package:flutter/material.dart';
import '../models/Event.dart';
import 'event_screen.dart';
import '../controllers/eventsController.dart';

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
  List<dynamic> savedEventsList = [];


  Future<Map<dynamic,dynamic>> loadSavedEvents() async {
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
    savedEventsList.addAll(widget.savedEvents.values.toList());
  }

  void pushEventScreen(int clickedEvent) async {
    final updatedEvent = await Navigator.push(context, MaterialPageRoute(builder: (context) => Events(event: savedEventsList[clickedEvent])));
    if (updatedEvent != null) {
      setState(() {
        savedEventsList[clickedEvent] = updatedEvent; //for favourite coherence between views.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text("Els teus events preferits!"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: savedEventsList.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                    key: ValueKey(savedEventsList[index].title),
                    contentPadding: EdgeInsets.all(20.0),
                    title: Text(savedEventsList[index].title),
                    leading:
                        Icon(Icons.event, color: Colors.black, size: 30),
                    trailing: IconButton(
                      iconSize: 25,
                      icon: Icon(Icons.favorite,
                          color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          widget.savedEvents.remove(savedEventsList[index].code);
                          EventsController controller = EventsController(context);
                          controller.unsaveEvent(savedEventsList[index].code);
                        });
                        loadSavedEvents().then((value){
                          savedEventsList.clear();
                          setState(() {
                            savedEventsList.addAll(value.values.toList());
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
        ],
      ),
    );
  }
}

