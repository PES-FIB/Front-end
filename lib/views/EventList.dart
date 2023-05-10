import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:prova_login/views/main_screen.dart';
import 'event_screen.dart';
import '../controllers/eventsController.dart';
import '../controllers/ambitsController.dart';
import '../models/Event.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';


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

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  bool _isAmbitsVisible = false;
  bool _isSearchBarVisible = false;
  

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

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    print(args.value);
}


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:
      Column(
        children: [
        
          Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [ 
                    SizedBox(width: 10, height: 70),
                    Text("Filtra els events:"),
                    SizedBox(width: 5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      
                        ElevatedButton(
                          onPressed: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Select Date Range'),
                                  content: Container(
                                    width: double.maxFinite,
                                    height: 300,
                                    child: SfDateRangePicker(
                                      view: DateRangePickerView.year,
                                      monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                                      onSelectionChanged: _onSelectionChanged,
                                      selectionMode: DateRangePickerSelectionMode.range,
                                    ),
                                  ),
                                
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('CANCEL'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        //final selectedRange = _datePicker.controller.selectedRange;
                                        //Navigator.of(context).pop(selectedRange);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
              
                            if (result != null &&
                                result.startDate != null &&
                                result.endDate != null) {
                              setState(() {
                                _startDate = result.startDate!;
                                _endDate = result.endDate!;
                              });
              
                              // update the filter based on the selected date range
                              // ...
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent), 
                          ),
                          child: Text('Date Range'),
                        ),
                      ],
                  ),
                  SizedBox(width: 5),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent), 
                    ),
                    onPressed: () {
                      setState(() {
                        _isAmbitsVisible = !_isAmbitsVisible;
                      });
                    },
                    child: Text('Ambits'),
                  ),
                  SizedBox(width: 5),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent), 
                    ),
                    onPressed: () {
                      setState(() {
                        _isSearchBarVisible = !_isSearchBarVisible;
                      });
                    },
                    child: Text('Search!'),
                  ),
                  SizedBox(height: 70),
                 ]
                ),
              ),
            ],
          ),
          
          
          //ambits
          Visibility(
            visible: _isAmbitsVisible,
            child: FutureBuilder<List<String>>(
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
          ),
          //cercador
          Visibility(
            visible: _isSearchBarVisible,
            child: Padding( 
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                onChanged: (value) => _runFilter(value),
                decoration: InputDecoration(
                  hintText: "busca un event" ,suffixIcon: Icon(Icons.search), contentPadding: EdgeInsets.all(20.0),
                ),
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
