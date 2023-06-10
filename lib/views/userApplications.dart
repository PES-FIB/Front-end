import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:prova_login/controllers/EventsController.dart';
import '../models/AppEvents.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/Formulari.dart';

class userApplications extends StatefulWidget {
  @override
  State<userApplications> createState() {
    return _userApplicationsState();
  }
}

class _userApplicationsState extends State<userApplications> {
  int pageStatus = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.redAccent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "C U L T U R I C A 'T",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            body: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    tooltip: 'Torna al perfil',
                    style: IconButton.styleFrom(shape: CircleBorder()),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.005,
                        right: MediaQuery.of(context).size.width * 0.054),
                    child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.redAccent,
                        child: IconButton(
                          tooltip: 'Recargar',
                          style: IconButton.styleFrom(shape: CircleBorder()),
                          onPressed: () async {
                            setState(() {
                              pageStatus = 1;
                            });
                            AppEvents.userForms =
                                await EventsController.getUserForms();
                            setState(() {
                              pageStatus = 0;
                            });
                          },
                          icon: Icon(Icons.refresh, color: Colors.white),
                        )),
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Text(
                'LES MEVES SOL·LICITUDS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              const Divider(),
              pageStatus == 0
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          itemCount: AppEvents.userForms.length,
                          itemBuilder: (context, index) {
                            Formulari f = AppEvents.userForms[index];
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: Colors
                                    .grey, // Replace with the desired border color
                                width: 1.0, // Adjust the border width as needed
                              )),
                              child: ListTile(
                                  tileColor: Colors.white,
                                  contentPadding: EdgeInsets.all(20.0),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(f.formulari_name,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20)),
                                      SizedBox(height: 5),
                                      Text(f.denomination_event,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15)),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                  leading: Icon(LineAwesomeIcons.folder,
                                      color: Colors.black, size: 30),
                                  trailing: Column(
                                    children: [
                                      Text('Estat'),
                                      Icon(Icons.brightness_1,
                                          color: f.formulari_status == 'pending'
                                              ? Colors.orange
                                              : f.formulari_status == 'rejected'
                                                  ? Colors.red
                                                  : Colors.green,
                                          size: 30),
                                    ],
                                  ),
                                  onTap: () {
                                    print(
                                        'quin estatus esta el form: ${f.formulari_status}');
                                  }),
                            );
                          }))
                  : pageStatus == 1
                      ? SizedBox(
                          child: SpinKitFadingCircle(
                          size: MediaQuery.of(context).size.height * 0.08,
                          color: Colors.redAccent,
                        ))
                      : SizedBox()
            ])));
  }
}
