import 'package:flutter/material.dart';
import 'EventList.dart';

class Events extends StatefulWidget {

  const Events({super.key, required this.event});
  final Event event;

  @override
  _EventsState createState() => _EventsState();
}
  
class _EventsState extends State<Events> { 
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      //AppBar
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, widget.event), //retuning to homePage and updating current event if necessary. 
        ), 
        automaticallyImplyLeading: false,
        backgroundColor: Colors.redAccent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "C U L T U R I C A 'T",
          style: TextStyle(
            color:Colors.white,
            fontWeight: FontWeight.bold),
        ),
      ),
      
      //body
      body: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
      
        child: Column( //main column
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row( // date, title
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        '01',
                        style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      
                      Text(
                        'April',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.title,
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 30.0),
                
              ],
            ),
           
            Column(
            
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.0),
                Image.network( //event image
                    'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
                    width: 350,
                    height: 150,
                    alignment:Alignment.center,
                    fit:BoxFit.cover,
                ),
                SizedBox(height: 15.0),

                Container( //conainer info
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 228, 228, 228),
                  ),

                  child: Column(
                    children: [
                      Text(
                        widget.event.description,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 25.0),

                      Row(
                        children: [
                          Icon(Icons.place),
                          SizedBox(width: 10.0),
                          Text(
                            'Esparreguera, La Passió',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.date_range),
                          SizedBox(width: 10.0),
                          Text(
                            'divendres 01 abril, 20:00h',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black
                            ),
                          ),
                        ],
                      ),      
                      Row(
                        children: [
                          Icon(Icons.link),
                          SizedBox(width: 10.0),
                          Text(
                            "https://lapassio.net/https://lapassio.net/",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black
                            ),
                          ),
                        ],
                      ),      
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                IconButton(
                  iconSize: 30,
                  icon: Icon(Icons.favorite, color: widget.event.fav ? Colors.redAccent: Color.fromARGB(255, 182, 179, 179),),
                  onPressed: () {
                    setState(() {  
                      widget.event.fav = !widget.event.fav;
                    });
                  },
                ),

              ],
          ),
        ],
      ),
      ),

    );
  }
}
