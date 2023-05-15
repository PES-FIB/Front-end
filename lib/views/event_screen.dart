

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../models/Event.dart';
import 'package:url_launcher/url_launcher.dart';
import '../views/review_screen.dart';
import 'styles/share_button.dart';

class Events extends StatefulWidget {

  const Events({super.key, required this.event});
  final Event event;

  @override
  _EventsState createState() => _EventsState();
}
  
class _EventsState extends State<Events> { 
  bool amplia = false;

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


    return  Scaffold(

        //body
        body: Container(
          //margin: EdgeInsets.all(16.0),
          padding: EdgeInsets.all(16.0),
        
          child: SingleChildScrollView(
            child: Column( //main column
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20,),
                  onPressed: () => Navigator.pop(context, widget.event), //retuning to homePage and updating current event if necessary. 
                ), 
                Row( // date, title
                  children: [                
                    Expanded(
                      flex: 2,
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
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.event.title,
                            style: TextStyle(
                              fontSize:30.0,
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
                
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 228, 228, 228),
                      ),
              
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.event.description,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 25.0),
              
                          
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
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
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
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
                          ),
                           SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                             child: Row(
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
                           ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
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
                          ), 
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
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
                          ),        
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
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
                                      }
                                    }
                                  ),
                                )],
                            ),
                          ),
                          if (widget.event.url != null)
                            //espacio de 10p
                            SizedBox(height: 10.0),
                          if (widget.event.url != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ShareButton(widget.event, widget.event.url)
                              ],
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                  //boton para ir a la pagina de valoraciones
                    ElevatedButton(
                     style: ButtonStyle(
                      
                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 228, 228, 228)), 
                      elevation: MaterialStateProperty.all<double>(1),
                      ),
                      child: Center(
                        child: Text(
                          "Valoracions",
                          style: TextStyle(color: Colors.black), // Change the color here
                        ),
                        
                      ),
                      
                      onPressed: () async {
                         await showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: ReviewPage(widget.event),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 10.0),
                    
                  ],
              ),
              Visibility(
                visible: amplia,
                child: ReviewPage(widget.event))
            ],
          ),
          ),
          
        ),
        //boton de compartir
    );
  }
}
