import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'EventList.dart';
import 'event_screen.dart';
import '../controllers/eventsController.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  
  Map<String, Event> mapSavedEvents = {};
  List<Event> savedEvents = [];
  int length = 0;

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    mapSavedEvents = await EventsController.getSavedEvents();
    savedEvents = mapSavedEvents.values.toList();
    length = savedEvents.length;

  }

  void pushEventScreen(int clickedEvent) async {
    final updatedEvent = await Navigator.push(context, MaterialPageRoute(builder: (context) => Events(event: savedEvents[clickedEvent])));
    if (updatedEvent != null) {
      setState(() {
        savedEvents[clickedEvent] = updatedEvent; //for favourite coherence between views.
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
              itemCount: savedEvents.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                    key: ValueKey(savedEvents[index].title),
                    contentPadding: EdgeInsets.all(20.0),
                    title: Text(savedEvents[index].title),
                    subtitle: Text(savedEvents[index].description),
                    leading:
                        Icon(Icons.event, color: Colors.black, size: 30),
                    trailing: IconButton(
                      iconSize: 25,
                      icon: Icon(Icons.favorite,
                          color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          mapSavedEvents.remove(savedEvents[index].code);
                          EventsController controller = EventsController(context);
                          controller.unsaveEvent(savedEvents[index].code);
                          loadEvents();
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

