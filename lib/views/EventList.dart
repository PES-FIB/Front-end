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
  
  const EventList({
    Key? key,
    required this.events,
    required this.savedEvents,
  }) : super(key: key);

  @override
  _EventListState createState() => _EventListState();

}

class _EventListState extends State<EventList> {

  late Future<List<String>> ambits; //list of all ambits 
  
  List<Event> _foundEvents = [];  
  List<Event> filteredEvents = []; 

  List<Color> backgroundColor = []; 
  String wordSearched = '';
  

 
 
  Future<List<String>> fetchAmbits() async {
    List<String> result = await AmbitsController.getAllAmbits();
    setState(() {
      backgroundColor.addAll(List.generate(result.length, (_) => Colors.white)); 
    });
    return result;
  }


  bool anyAmbitSelected () {
    bool selected = false;
    for(int i = 0; i < backgroundColor.length; ++i) {
      if (backgroundColor[i] == Color.fromARGB(255, 235, 235, 235)) selected = true;
    }
    return selected;
  }

  
  @override
  void initState() {
    super.initState();
    setState(() {
      filteredEvents.addAll(widget.events);
      _foundEvents.addAll(filteredEvents);
      ambits = fetchAmbits();
    });
  } 


  bool inSaved(String codeEvent){
    return widget.savedEvents.containsKey(codeEvent);
  }


  void _runFilter(String enteredTitle) {
     List<Event> result = [];
    if(enteredTitle.isEmpty) {
      result = filteredEvents;
    } else {
      result = filteredEvents.where((event) => event.title.toLowerCase().contains(enteredTitle.toLowerCase())).toList();
    }
    setState(() {
      wordSearched = enteredTitle;
      _foundEvents = result;});
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
          SizedBox(height: 20.0),
          //ambits
          FutureBuilder<List<String>>(
            future: ambits,
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
                              String ambit = snapshot.data![index];
                              //return AmbitContainer(ambitName: name);
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    bool beforeState = anyAmbitSelected(); //checking if it's the first selected.
                                    backgroundColor[index] = backgroundColor[index] == Colors.white ? Color.fromARGB(255, 235, 235, 235) : Colors.white;
                                    //si des-seleccionat
                                    if (backgroundColor[index] == Colors.white) {
                                      if (!anyAmbitSelected()) {
                                        filteredEvents.clear();
                                        filteredEvents.addAll(widget.events);
                                       } else {
                                        filteredEvents.removeWhere((event) => event.ambits.contains(ambit));
                                      }
                                      _runFilter(wordSearched);
                                    }
                                    //si seleccionat
                                    else {
                                      if(!beforeState) filteredEvents.clear(); 
                                      EventsController.getEventsByAmbit(ambit).then((value) {setState(() {
                                        filteredEvents.addAll(value);
                                        _runFilter(wordSearched);
                                      });});
                                    }
                                  });
                                },
                                child: Container(
                                  width: 130,
                                  margin: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: backgroundColor[index],
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
                                      ambit,
                                      textAlign: TextAlign.center,
                                    ),
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
          //cercador
          Padding( 
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: "busca un event" ,suffixIcon: Icon(Icons.search), contentPadding: EdgeInsets.all(20.0),
              ),
            ),
          ),
          //lista d'events
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
