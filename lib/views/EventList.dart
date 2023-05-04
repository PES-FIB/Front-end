import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:prova_login/views/main_screen.dart';
import 'event_screen.dart';
import '../controllers/eventsController.dart';
import '../models/Event.dart';
import '../models/AppEvents.dart';


class EventList extends StatefulWidget {
  //final VoidCallback onNavigate;
  
  const EventList({
    Key? key,
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

/*
  Future<List<Event>> loadAllEvents() async {
    return await EventsController.getAllEvents();
  }

  Future<Map<String,Event>> loadSavedEvents() async {
    return await EventsController.getSavedEvents();
  }

*/
  
  @override
  void initState() {
    super.initState();
    setState(() {
    });
    /*
    loadAllEvents().then((value){
       setState(() {
        events.addAll(value);
        _foundEvents.addAll(value);
      });
    });

    loadSavedEvents().then((value){
       setState(() {
        saved.addAll(value);
      });
    });*/
  } 


  bool inSaved(String codeEvent){
    return AppEvents.savedEvents.containsKey(codeEvent);
  }

  void _runFilter(String enteredTitle) {
    if(enteredTitle.isEmpty) {
      result = AppEvents.eventsList;
    } else {
      result = AppEvents.eventsList.where((event) => event.title.toLowerCase().contains(enteredTitle.toLowerCase())).toList();
    }
    setState(() {_foundEvents = result;});
  }

  void pushEventScreen(int clickedEvent) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => Events(event: AppEvents.eventsList[clickedEvent])));
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
                        AppEvents.savedEvents.remove(_foundEvents[index].code);
                        AppEvents.savedEventsCalendar[DateUtils.dateOnly(DateUtils.dateOnly(DateTime.parse(_foundEvents[index].initialDate)))]?.remove(_foundEvents[index]);
                        controller.unsaveEvent(_foundEvents[index].code);
                      }//remove
                      else {
                        AppEvents.savedEvents[_foundEvents[index].code] = _foundEvents[index];
                        if( AppEvents.savedEventsCalendar.containsKey(DateUtils.dateOnly(DateTime.parse(_foundEvents[index].initialDate)))) {
                          AppEvents.savedEventsCalendar[DateUtils.dateOnly(DateUtils.dateOnly(DateTime.parse(_foundEvents[index].initialDate)))]?.add(_foundEvents[index]);
                        }
                        else {
                          List<Event> l = [_foundEvents[index]];
                          AppEvents.savedEventsCalendar[DateUtils.dateOnly(DateUtils.dateOnly(DateTime.parse(_foundEvents[index].initialDate)))] = l;
                        }
                        print('lhe guardat al front ${AppEvents.savedEventsCalendar[DateUtils.dateOnly(DateUtils.dateOnly(DateTime.parse(_foundEvents[index].initialDate)))]}');
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