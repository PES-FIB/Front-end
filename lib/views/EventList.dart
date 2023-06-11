import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'event_screen.dart';
import '../controllers/eventsController.dart';
import '../models/Event.dart';
import '../models/AppEvents.dart';

class EventList extends StatefulWidget {
  const EventList({
    Key? key,
    //required this.onNavigate,
  }) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  List<Event> _foundEvents = [];
  List<Event> filteredEvents = [];

  List<Color> backgroundColor = [];
  String wordSearched = '';

  String selectedAmbit = "Tots els events";
  List<String> ambits = [];

  DateTimeRange selectedDates =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  String dataIni = "";
  String dataFi = "";

  bool _isSearchBarVisible = false;
  bool rangeSelected = false;
  bool _isRecommendedVisible = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      filteredEvents = List.from(AppEvents.eventsList);
      _foundEvents.addAll(filteredEvents);
      ambits.add("Tots els events");
      ambits.addAll(AppEvents.ambits);
    });
  }

  void filterByAmbit() {
    if (selectedAmbit != "Tots els events") {
      filteredEvents = List.from(AppEvents.eventsList
          .where((event) => event.ambits.contains(selectedAmbit)));
    } else {
      filteredEvents = List.from(AppEvents.eventsList);
    }
  }

  bool inSaved(String codeEvent) {
    return AppEvents.savedEvents.containsKey(codeEvent);
  }

  void _runSearchFilter(String enteredTitle) {
    List<Event> result = [];
    if (enteredTitle.isEmpty) {
      result = filteredEvents;
    } else {
      result = filteredEvents
          .where((event) =>
              event.title.toLowerCase().contains(enteredTitle.toLowerCase()))
          .toList();
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
          child: Events(event: _foundEvents[clickedEvent]),
        );
      },
    );
  }

  void pushRecommended(int clickedEvent) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Events(event: AppEvents.recommendedEvents[clickedEvent]),
        );
      },
    );
  }

  void filterByDateRange() async {
    //year-month-day
    List<String> dirtyInitDate = selectedDates.start.toString().split(" ");
    //[year] [month] [day]
    List<String> initDate = dirtyInitDate[0].split("-");
    //month/day/year
    String queryInitDate = initDate[1] + "/" + initDate[2] + "/" + initDate[0];
    print(queryInitDate);

    //year-month-day
    List<String> dirtyFinalDate = selectedDates.end.toString().split(" ");
    //[year] [month] [day]
    List<String> finalDate = dirtyFinalDate[0].split("-");
    //month/day/year
    String queryFinalDate =
        finalDate[1] + "/" + finalDate[2] + "/" + finalDate[0];
    print(queryFinalDate);

    dataIni = initDate[2] + "/" + initDate[1] + "/" + initDate[0];
    dataFi = finalDate[2] + "/" + finalDate[1] + "/" + finalDate[0];

    List<Event> tmp = await EventsController.getEventsByDateRange(
        queryInitDate, queryFinalDate);

    List<Event> result = [];
    for (Event event in filteredEvents) {
      if (tmp.any((tmpEvent) => tmpEvent.code == event.code)) {
        result.add(event);
      }
    }
    setState(() {
      filteredEvents.clear();
      filteredEvents.addAll(result);
      _runSearchFilter(wordSearched);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          //filtres
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 0.5, color: Colors.grey)),
                    child: DropdownButton(
                      value: selectedAmbit,
                      onChanged: (value) {
                        setState(() {
                          selectedAmbit = value as String;
                          filterByAmbit();
                          _runSearchFilter(wordSearched);
                        });
                      },
                      items: ambits.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(width: 3),
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 0.5, color: Colors.grey)),
                    child: IconButton(
                      iconSize: 25,
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _isSearchBarVisible = !_isSearchBarVisible;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 3),
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 0.5, color: Colors.grey)),
                    child: IconButton(
                      iconSize: 27,
                      icon: Icon(LineAwesomeIcons.alternate_calendar),
                      onPressed: () async {
                        final DateTimeRange? dateTimeRange =
                            await showDateRangePicker(
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
                          firstDate: DateTime.now(),
                          lastDate: DateTime(3000),
                          initialDateRange: selectedDates,
                        );
                        if (dateTimeRange != null) {
                          setState(() {
                            selectedDates = dateTimeRange;
                            filterByDateRange();
                            rangeSelected = true;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 3),
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 0.5, color: Colors.grey)),
                    child: IconButton(
                      iconSize: 27,
                      icon: Icon(LineAwesomeIcons.calendar_times),
                      onPressed: () {
                        if (rangeSelected) {
                          setState(() {
                            filterByAmbit();
                            _runSearchFilter(wordSearched);
                            rangeSelected = false;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 3),
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 0.5, color: Colors.grey)),
                    child: IconButton(
                      iconSize: 27,
                      icon: Icon(LineAwesomeIcons.info),
                      onPressed: () {
                        setState(() {
                          _isRecommendedVisible = !_isRecommendedVisible;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
            child: Visibility(
              visible: _isSearchBarVisible,
              child: TextField(
                onChanged: (value) => _runSearchFilter(value),
                decoration: InputDecoration(
                  hintText: "Cerca un event",
                  suffixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.all(20.0),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Visibility(
              visible: rangeSelected,
              child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 145, 145),
                  ),
                  child: Text("Events del " + dataIni + " a " + dataFi)),
            ),
          ),
          _isRecommendedVisible
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Column(
                    children: [
                      Text(
                        'Recomanacions',
                        style: TextStyle(
                          fontFamily:
                              'CoolFont', // Replace with your desired custom font
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: AppEvents.recommendedEvents.length,
                          itemBuilder: (BuildContext context, int index) {
                            Event event = AppEvents.recommendedEvents[index];
                            return GestureDetector(
                              onTap: () {
                                pushRecommended(index);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Container(
                                  width:
                                      200, // Set the desired fixed width for the event tile container
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(8.0),
                                        ),
                                        child: Image.network(
                                          event.imageLink == null ||
                                                  event.imageLink == ""
                                              ? "https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/Logotipo_de_la_Generalitat_de_Catalunya.svg/1200px-Logotipo_de_la_Generalitat_de_Catalunya.svg.png"
                                              : event.imageLink,
                                          width: 200,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              event.title,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              '${event.city.substring(0,1).toUpperCase()}${event.city.substring(1,event.city.length)} - ${event.initialDate.substring(0,10)}',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ))
              : SizedBox(height: 0),
          //llista d'events
          Expanded(
            child: ListView.builder(
              itemCount: _foundEvents.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                    key: ValueKey(_foundEvents[index].code),
                    contentPadding: EdgeInsets.all(20.0),
                    title: Text(_foundEvents[index].title),
                    subtitle: Text(
                        _foundEvents[index].initialDate.substring(0, 10) +
                            ", " +
                            _foundEvents[index].city),
                    leading: Icon(LineAwesomeIcons.calendar,
                        color: Colors.black, size: 30),
                    trailing: IconButton(
                      iconSize: 25,
                      icon: Icon(Icons.favorite,
                          color: inSaved(_foundEvents[index].code)
                              ? Colors.redAccent
                              : Color.fromARGB(255, 182, 179, 179)),
                      onPressed: () {
                        setState(() {
                          if (inSaved(_foundEvents[index].code)) {
                            EventsController.unsaveEvent(
                                _foundEvents[index].code);
                            EventsController.unsaveEventLocale(
                                _foundEvents[index]);
                            AppEvents.savedChanged = true;
                          } //remove
                          else {
                            EventsController.saveEvent(
                                _foundEvents[index].code);
                            EventsController.saveEventLocale(
                                _foundEvents[index]);
                            AppEvents.savedChanged = true;
                          } //add
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
    ));
  }
}
