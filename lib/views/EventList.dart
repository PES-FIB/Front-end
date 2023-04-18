import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:prova_login/views/main_screen.dart';
import 'event_screen.dart';
import '../controllers/eventsController.dart';
import '../controllers/ambitsController.dart';
import '../models/Event.dart';


class EventList extends StatefulWidget {
  final List<Event> events;
  final Map<dynamic, dynamic> savedEvents;
  
  //final VoidCallback onNavigate;
  
  const EventList({
    Key? key,
    required this.events,
    required this.savedEvents,
    //required this.onNavigate,
  }) : super(key: key);

  @override
  _EventListState createState() => _EventListState();

}

class _EventListState extends State<EventList> {


  List<Event> events = [];
  Map<dynamic,dynamic> saved = {};
  List<Event> _foundEvents = [];
  List<Event> result = [];
  List<String> ambits = [];

  Future<List<String>> fetchAmbits() async {
    List<String> result = await AmbitsController.getAllAmbits();
    print(result.length);
    return result;
  }

  
  @override
  void initState() {
    super.initState();
    setState(() {
      events.addAll(widget.events);
      _foundEvents.addAll(widget.events);
      saved.addAll(widget.savedEvents);
    });
  } 


  bool inSaved(String codeEvent){
    return widget.savedEvents.containsKey(codeEvent);
  }

  void _runFilter(String enteredTitle) {
    if(enteredTitle.isEmpty) {
      result = widget.events;
    } else {
      result = widget.events.where((event) => event.title.toLowerCase().contains(enteredTitle.toLowerCase())).toList();
    }
    setState(() {_foundEvents = result;});
  }

  void pushEventScreen(int clickedEvent) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => Events(event: widget.events[clickedEvent])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        children: [
          Padding( 
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: "busca un event" ,suffixIcon: Icon(Icons.search), contentPadding: EdgeInsets.all(20.0),
              ),
            ),
          ),
         
         
          FutureBuilder<List<String>>(
            future: fetchAmbits(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 130,
                                margin: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 1,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    snapshot.data![index],
                                    textAlign: TextAlign.center,
                                    
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _foundEvents.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  key: ValueKey(_foundEvents[index].code),
                  contentPadding: EdgeInsets.all(20.0),
                  title: Text(_foundEvents[index].title),
                  leading:  Icon(Icons.event, color: Colors.black, size: 30),
                  trailing: IconButton(
                    iconSize: 25,
                    icon: Icon(Icons.favorite, color: inSaved(_foundEvents[index].code)? Colors.redAccent: Color.fromARGB(255, 182, 179, 179)),
                    onPressed: () {
                    setState(() {
                      EventsController controller = EventsController(context);
                      if (inSaved(_foundEvents[index].code)){
                        widget.savedEvents.remove(_foundEvents[index].code);
                        controller.unsaveEvent(_foundEvents[index].code);
                      }//remove
                      else {
                        widget.savedEvents[_foundEvents[index].code] = _foundEvents[index];
                        controller.saveEvent(_foundEvents[index].code);
                      }//add
                    });
                    },
                  ),
              
                  onTap: () { 
                    pushEventScreen(index);
                  }
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}