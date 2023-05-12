import 'dart:async';
import 'package:flutter/material.dart';
import 'event_screen.dart';
import '../controllers/eventsController.dart';
import '../models/Event.dart';
import '../models/AppEvents.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


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

  late Future<List<String>> ambits; //list of all ambits 
  
  List<Event> _foundEvents = [];  
  List<Event> filteredEvents = []; 
  List<Event> filteredEventsWithoutDataRangeFilter= [];


  List<Color> backgroundColor = []; 
  String wordSearched = '';

  bool _isAmbitsVisible = false;
  bool _isSearchBarVisible = false;
  bool rangeSelected = false;

  DateTimeRange selectedDates = DateTimeRange(start: DateTime.now(), end: DateTime.now()); 
  String dataIni = "";
  String dataFi = "";
  

  Future<List<String>> fetchAmbits() async {
    List<String> result = await EventsController.getAllAmbits();
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
      filteredEvents.addAll(AppEvents.eventsList);
      filteredEventsWithoutDataRangeFilter.addAll(AppEvents.eventsList);
      _foundEvents.addAll(filteredEvents);
      ambits = fetchAmbits();

    });
  } 


  bool inSaved(String codeEvent){
    return AppEvents.savedEvents.containsKey(codeEvent);
  }


  void _runSearchFilter(String enteredTitle) {
    List<Event> result = [];
    if(enteredTitle.isEmpty) {
      result = filteredEvents;
    } else {
      result = filteredEvents.where((event) => event.title.toLowerCase().contains(enteredTitle.toLowerCase())).toList();
    }
    setState(() {
      wordSearched = enteredTitle;
      _foundEvents = result;
    });
  }

  void pushEventScreen(int clickedEvent) async {
  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Events(event: AppEvents.eventsList[clickedEvent]),
      );
    },
  );
}
  
  void clearRangeDateFilter(){
    setState(() {
      filteredEvents.clear();
      filteredEvents.addAll(filteredEventsWithoutDataRangeFilter);
    });
  }

  void filterByDateRange() async{
  
  //year-month-day
  List<String>  dirtyInitDate = selectedDates.start.toString().split(" ");
  //[year] [month] [day] 
  List<String> initDate = dirtyInitDate[0].split("-");
  //month/day/year
  String queryInitDate = initDate[1] + "/" + initDate[2] + "/" + initDate[0];
  print(queryInitDate);

  //year-month-day
  List<String>  dirtyFinalDate = selectedDates.end.toString().split(" ");
  //[year] [month] [day] 
  List<String> finalDate = dirtyFinalDate[0].split("-");
  //month/day/year
  String queryFinalDate = finalDate[1] + "/" + finalDate[2] + "/" + finalDate[0];
  print(queryFinalDate);

  dataIni = initDate[2] + "/" + initDate[1] + "/" + initDate[0]; 
  dataFi = finalDate[2] + "/" + finalDate[1] + "/" + finalDate[0]; 

  List<Event> tmpByDateRange = await EventsController.getEventsByDateRange(queryInitDate, queryFinalDate);
  print(tmpByDateRange.length);
  print(filteredEventsWithoutDataRangeFilter.length);

  List<Event> result = [];
  for (Event event in filteredEventsWithoutDataRangeFilter) {
    if (tmpByDateRange.any((tmpEvent) => tmpEvent.code == event.code)) {
      result.add(event);
    }
  }

  setState(() {
    filteredEvents.clear();
    filteredEvents.addAll(result);
    print(filteredEvents.length);
    _runSearchFilter(wordSearched);
  });
}



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
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
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent), 
                          ),
                          child: const Text("Dates"),
                          onPressed: () async {
                            final DateTimeRange? dateTimeRange = await showDateRangePicker(
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Colors.redAccent, 
                                      onPrimary: Colors.white, 
                                      onSurface: Colors.grey, 
                                    ),
                                   ),
                                  child: child!,
                                );
                              },
                              context: context, 
                              firstDate: DateTime(2000), 
                              lastDate: DateTime(3000),
                              initialDateRange: selectedDates,
                            );
                            if(dateTimeRange != null) {
                              setState(() {
                                selectedDates = dateTimeRange;
                                filterByDateRange();
                                rangeSelected = true;
                              });
                            }
                          },
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
                    child: Text('Busca!'),
                  ),
                  SizedBox(height: 70),
                 ]
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Visibility(
                      visible: rangeSelected,
                      child: Row(
                      children: [
                        Text(" rang seleccionat:", textAlign: TextAlign.center,),
                        Text(" " + dataIni + " - " + dataFi + "   ",),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey), 
                          ),
                        onPressed: () {
                          setState(() {
                            rangeSelected = false;
                            selectedDates = DateTimeRange(start: DateTime.now(), end: DateTime.now());
                            clearRangeDateFilter();
                          });
                        },
                        child: Text('borrar filtre'),
                      ),
                      ],
                    ))
                  ],
                ),
              )
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
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      bool beforeState = anyAmbitSelected(); //checking if it's the first selected.
                                      backgroundColor[index] = backgroundColor[index] == Colors.white ? Color.fromARGB(255, 235, 235, 235) : Colors.white;
                                      //si des-seleccionat
                                      if (backgroundColor[index] == Colors.white) {
                                        if (!anyAmbitSelected()) {
                                          filteredEvents.clear();
                                          filteredEvents.addAll(AppEvents.eventsList);
                                        } else {
                                          filteredEvents.removeWhere((event) => event.ambits.contains(ambit));
                                        }
                                        _runSearchFilter(wordSearched);
                                      }
                                      //si seleccionat
                                      else {
                                        if(!beforeState) filteredEvents.clear(); 
                                        EventsController.getEventsByAmbit(ambit).then((value) {setState(() {
                                          filteredEvents.addAll(value);
                                          _runSearchFilter(wordSearched);
                                        });});
                                      }
                                      filteredEventsWithoutDataRangeFilter.clear();
                                      filteredEventsWithoutDataRangeFilter.addAll(filteredEvents);
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
                onChanged: (value) => _runSearchFilter(value),
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
                      if (inSaved(_foundEvents[index].code)){
                        EventsController.unsaveEvent(_foundEvents[index].code);
                        EventsController.unsaveEventLocale(_foundEvents[index]);
                      }//remove
                      else {
                        EventsController.saveEvent(_foundEvents[index].code);
                        EventsController.saveEventLocale(_foundEvents[index]);
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
