import 'dart:async';
import 'package:flutter/material.dart';
import 'event_screen.dart';
import '../controllers/eventsController.dart';
import '../controllers/ambitsController.dart';
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
  List<Event> dateRangeEvents = [];
  List<Event> filteredEventsWithoutDataRangeFilter= [];


  List<Color> backgroundColor = []; 
  String wordSearched = '';

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
      filteredEvents.addAll(AppEvents.eventsList);
      filteredEventsWithoutDataRangeFilter.addAll(AppEvents.eventsList);
      _foundEvents.addAll(filteredEvents);
      dateRangeEvents.addAll(filteredEvents);
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
    await Navigator.push(context, MaterialPageRoute(builder: (context) => Events(event: AppEvents.eventsList[clickedEvent])));
  }
  
  void clearRangeDateFilter(){
    //tornar posar tots aquells events que han estat filtrats per les dates.
    //fer un set state amb filteredEvents = filteredEventsWithoutDataRangeFilter.
    //en tot moment filteredEventsWithout es igual a filtered events menys per el datarange. 
    setState(() {
      filteredEvents.clear();
      filteredEvents.addAll(filteredEventsWithoutDataRangeFilter);
    });
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) async {
    if (args is PickerDateRange) {
      PickerDateRange range = args.value;
      print(range.startDate);
       print(range.endDate);
    }
    print("no entra");

/*
    //year-month-day
    List<String>  dirtyInitDate = range.startDate .value.startDate.toString().split(" ");
    //[year] [month] [day] 
    List<String> initDate = dirtyInitDate[0].split("-");
    //month/day/year
    String queryInitDate = initDate[1] + "/" + initDate[2] + "/" + initDate[0];
    print(queryInitDate);

    //year-month-day
    List<String>  dirtyFinalDate = args.value.endDate.toString().split(" ");
    //[year] [month] [day] 
    List<String> finalDate = dirtyInitDate[0].split("-");
    //month/day/year
    String queryFinalDate = finalDate[1] + "/" + finalDate[2] + "/" + finalDate[0];
    print(queryFinalDate);

    List<Event> tmpByDateRange = await EventsController.getEventsByDateRange(queryInitDate, queryFinalDate);
    print(tmpByDateRange.length);

    setState(() {
      dateRangeEvents.clear();
      dateRangeEvents.addAll(tmpByDateRange);
      filteredEvents.retainWhere((element) => tmpByDateRange.contains(element));
    });*/
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
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Select Date Range'),
                                  content: Container(
                                    width: double.maxFinite,
                                    height: 300,
                                    child: SfDateRangePicker(
                                      view: DateRangePickerView.month,
                                      selectionMode: DateRangePickerSelectionMode.range,
                                      showActionButtons: true,
                                      cancelText: 'CANCEL',
                                      confirmText: 'OK',  
                                      onCancel: () {
                                        Navigator.pop(context);
                                      },
                                      //onSubmit: ,
                                      
                                    ),
                                  ),
                                
                          
                                );
                              },
                            );
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
