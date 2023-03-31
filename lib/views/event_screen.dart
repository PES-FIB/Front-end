import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'EventList.dart';
import 'package:url_launcher/url_launcher.dart';

class Events extends StatefulWidget {

  const Events({super.key, required this.event});
  final Event event;

  @override
  _EventsState createState() => _EventsState();
}
  
class _EventsState extends State<Events> { 

  
  
  @override
  Widget build(BuildContext context) {

  String month = "";
  String month_number = widget.event.initialDate.substring(5,7);
  switch (month_number) {
      case "01":
        month = "gener";
        break;
      case "02":
        month = "febrer";
        break;
      case "03":
        month = "març";
        break;
      case "04":
        month = "abril";
        break;
      case "05":
        month = "maig";
        break;
      case "06":
        month = "juny";
        break;
      case "07":
        month = "juliol";
        break;
      case "08":
        month = "agost";
        break;
      case "09":
        month = "setembre";
        break;
      case "10":
        month = "octubre";
        break;
      case "11":
        month = "novembre";
        break;
      case "12":
        month = "desembre";
        break;
      default:
        month = "";
    }

    return Expanded
    (
      child: Scaffold(
    
        //AppBar
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context, widget.event), //retuning to homePage and updating current event if necessary. 
          ), 
          toolbarHeight: 70,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orange,
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
        
          child: SingleChildScrollView(
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
                            widget.event.initialDate.substring(8, 10),
                            style: TextStyle(
                              fontSize: 45.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          
                          Text(
                            month,
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
                    AspectRatio(
                      aspectRatio: 2.0/1.0,
                      child: Image.network( //event image
                          widget.event.imageLink,
                         width: 350,
                          height: 175,
                          alignment:Alignment.center,
                          fit:BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 15.0),
              
                    Container( //conainer info
                      margin: EdgeInsets.all(8.0),
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
                              Icon(Icons.location_city),
                              SizedBox(width: 10.0),
                              Text(
                                widget.event.city,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.place),
                              SizedBox(width: 10.0),
                              Text(
                                widget.event.adress,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                           Row(
                            children: [
                              Icon(Icons.money),
                              SizedBox(width: 10.0),
                              Text(
                                widget.event.tickets,
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
                                widget.event.initialDate.substring(0, 10),
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black
                                ),
                              ),
                            ],
                          ), 
                          Row(
                            children: [
                              Icon(Icons.schedule),
                              SizedBox(width: 10.0),
                              Text(
                                widget.event.schedule,
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
                              Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.redAccent,
                                  ),
                                  text: widget.event.url,
                                  recognizer: TapGestureRecognizer()..onTap = () async {
                                    var url = Uri.parse(widget.event.url);
                                    var urllaunchable = await canLaunchUrl(url);
                                    if (urllaunchable) {
                                      await launchUrl(url);
                                    } else {
                                      print("URL can't be launched");
                                    }
                                  }
                                ),
                              ),
                            ],
                          ),      
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    /*
                    IconButton(
                      iconSize: 30,
                      icon: Icon(Icons.favorite, color: widget.event.fav ? Colors.redAccent: Color.fromARGB(255, 182, 179, 179),),
                      onPressed: () {
                        setState(() {  
                          //widget.event.fav = !widget.event.fav;
                        });
                      },
                    ),
              */
                  ],
              ),
            ],
                  ),
          ),
        ),
    
      ),
    );
  }
}
