import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../models/AppEvents.dart';
import '../models/Event.dart';
import 'package:share_plus/share_plus.dart';
import '../models/Formulari.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';
import '../models/User.dart';
import '../APIs/reportsApis.dart';

class EventsController {
  final BuildContext context;
  EventsController(this.context);

  static Future<List<Event>> getAllEvents() async {
    List<Event> allEvents = []; //initialize empty event list.
    try {
      //request events
      final response =
          await dio.get('http://nattech.fib.upc.edu:40331/api/v1/events');

      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          for (int i = 0; i < response.data['data'].length; ++i) {
            //response is already decoded.
            String code;
            if (response.data['data'][i]['code'] == null) {
              code = "";
            } else {
              code = response.data['data'][i]['code'];
            }

            String denomination;
            if (response.data['data'][i]['denomination'] == null) {
              denomination = "";
            } else {
              denomination = response.data['data'][i]['denomination'];
            }

            String description;
            if (response.data['data'][i]['description'] == null) {
              description = "";
            } else {
              description = response.data['data'][i]['description'];
            }
            String image;
            if (response.data['data'][i]['images'] == null) {
              image = "";
            } else {
              image = response.data['data'][i]['images'][0];
            }
            String url;
            if (response.data['data'][i]['url'] == null) {
              url = "";
            } else {
              url = response.data['data'][i]['url'];
            }

            String initD;
            if (response.data['data'][i]['initial_date'] == null) {
              initD = "";
            } else {
              initD = response.data['data'][i]['initial_date'];
            }

            String finalD;
            if (response.data['data'][i]['final_date'] == null) {
              finalD = "";
            } else {
              finalD = response.data['data'][i]['final_date'];
            }

            String schedule;
            if (response.data['data'][i]['schedule'] == null) {
              schedule = "";
            } else {
              schedule = response.data['data'][i]['schedule'];
            }

            String city;
            if (response.data['data'][i]['region'] == null ||
                response.data['data'][i]['region'].length < 3) {
              city = "";
            } else {
              city = response.data['data'][i]['region'][2];
            }

            String adress;
            if (response.data['data'][i]['address'] == null) {
              adress = "";
            } else {
              adress = response.data['data'][i]['address'];
            }

            String tickets;
            if (response.data['data'][i]['tickets'] == null) {
              tickets = "";
            } else {
              tickets = response.data['data'][i]['tickets'];
            }

            String latitude;
            if (response.data['data'][i]['latitude'] == null) {
              latitude = "";
            } else {
              latitude = response.data['data'][i]['latitude'];
            }

            String longitude;
            if (response.data['data'][i]['longitude'] == null) {
              longitude = "";
            } else {
              longitude = response.data['data'][i]['longitude'];
            }
            List<dynamic> ambits = [];
            if (response.data['data'][i]['ambits'] != null)
              ambits.addAll(response.data['data'][i]['ambits']);

            Event event = Event(
              code,
              denomination,
              description,
              image,
              url,
              initD,
              finalD,
              schedule,
              city,
              adress,
              tickets,
              latitude,
              longitude,
              ambits,
            );

            allEvents.add(event);
          }

          return allEvents;
        }
      }
      return []; // return an empty list if there was an error
    } catch (error) {
      return []; // return an empty list if there was an error
    }
  }

  static Future<List<Event>> getMapEvents() async {
    List<Event> mapEvents = []; //initialize empty event list.
    try {
      //request events
      final response = await dio
          .get('http://nattech.fib.upc.edu:40331/api/v1/events/eventsMap');

      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          for (int i = 0; i < response.data['data'].length; ++i) {
            //response is already decoded.
            String code;
            if (response.data['data'][i]['code'] == null) {
              code = "";
            } else {
              code = response.data['data'][i]['code'];
            }

            String denomination;
            if (response.data['data'][i]['denomination'] == null) {
              denomination = "";
            } else {
              denomination = response.data['data'][i]['denomination'];
            }

            String description;
            if (response.data['data'][i]['description'] == null) {
              description = "";
            } else {
              description = response.data['data'][i]['description'];
            }
            String image;
            if (response.data['data'][i]['images'] == null) {
              image = "";
            } else {
              image = response.data['data'][i]['images'][0];
            }
            String url;
            if (response.data['data'][i]['url'] == null) {
              url = "";
            } else {
              url = response.data['data'][i]['url'];
            }

            String initD;
            if (response.data['data'][i]['initial_date'] == null) {
              initD = "";
            } else {
              initD = response.data['data'][i]['initial_date'];
            }

            String finalD;
            if (response.data['data'][i]['final_date'] == null) {
              finalD = "";
            } else {
              finalD = response.data['data'][i]['final_date'];
            }

            String schedule;
            if (response.data['data'][i]['schedule'] == null) {
              schedule = "";
            } else {
              schedule = response.data['data'][i]['schedule'];
            }

            String city;
            if (response.data['data'][i]['region'] == null ||
                response.data['data'][i]['region'].length < 3) {
              city = "";
            } else {
              city = response.data['data'][i]['region'][2];
            }

            String adress;
            if (response.data['data'][i]['address'] == null) {
              adress = "";
            } else {
              adress = response.data['data'][i]['address'];
            }

            String tickets;
            if (response.data['data'][i]['tickets'] == null) {
              tickets = "";
            } else {
              tickets = response.data['data'][i]['tickets'];
            }

            String latitude;
            if (response.data['data'][i]['latitude'] == null) {
              latitude = "";
            } else {
              latitude = response.data['data'][i]['latitude'];
            }

            String longitude;
            if (response.data['data'][i]['longitude'] == null) {
              longitude = "";
            } else {
              longitude = response.data['data'][i]['longitude'];
            }
            List<dynamic> ambits = [];
            if (response.data['data'][i]['ambits'] != null)
              ambits.addAll(response.data['data'][i]['ambits']);

            Event event = Event(
              code,
              denomination,
              description,
              image,
              url,
              initD,
              finalD,
              schedule,
              city,
              adress,
              tickets,
              latitude,
              longitude,
              ambits,
            );

            mapEvents.add(event);
          }

          return mapEvents;
        }
      }
      return []; // return an empty list if there was an error
    } catch (error) {
      return []; // return an empty list if there was an error
    }
  }

  static Future<void> getSavedEvents() async {
    try {
      //request current user saved events
      final response = await dio
          .get('http://nattech.fib.upc.edu:40331/api/v1/users/savedEvents');

      //cheking events response

      if (response.statusCode == 200) {
        if (response.data['events'] != null) {
          for (int i = 0; i < response.data['events'].length; ++i) {
            //response is already decoded.
            String image;
            if (response.data['events'][i]['images'] == null) {
              image = "";
            } else {
              image = response.data['events'][i]['images'][0];
            }

            String url;
            if (response.data['events'][i]['url'] == null) {
              url = "";
            } else {
              url = response.data['events'][i]['url'];
            }

            String initD;
            if (response.data['events'][i]['initial_date'] == null) {
              initD = "";
            } else {
              initD = response.data['events'][i]['initial_date'];
            }

            String finalD;
            if (response.data['events'][i]['final_date'] == null) {
              finalD = "";
            } else {
              finalD = response.data['events'][i]['final_date'];
            }

            String schedule;
            if (response.data['events'][i]['schedule'] == null) {
              schedule = "";
            } else {
              schedule = response.data['events'][i]['schedule'];
            }

            String city;
            if (response.data['events'][i]['region'] == null ||
                response.data['events'][i]['region'].length < 3) {
              city = "";
            } else {
              city = response.data['events'][i]['region'][2];
            }

            String adress;
            if (response.data['events'][i]['adress'] == null) {
              adress = "";
            } else {
              adress = response.data['events'][i]['adress'];
            }

            String tickets;
            if (response.data['events'][i]['tickets'] == null) {
              tickets = "";
            } else {
              tickets = response.data['events'][i]['tickets'];
            }
            String latitude = "";
            if (response.data['events'][i]['latitude'] != null) {
              latitude = response.data['events'][i]['latitude'];
            }
            String longitude = "";
            if (response.data['events'][i]['longitude'] != null) {
              longitude = response.data['events'][i]['longitude'];
            }

            List<dynamic> ambits = [];
            if (response.data['events'][i]['ambits'] != null)
              ambits.addAll(response.data['events'][i]['ambits']);

            Event event = Event(
                response.data['events'][i]['code'],
                response.data['events'][i]['denomination'],
                response.data['events'][i]['description'],
                image,
                url,
                initD,
                finalD,
                schedule,
                city,
                adress,
                tickets,
                latitude,
                longitude,
                ambits);
            saveEventLocale(event);
          }
        }
      }
    } catch (error) {
      return; // return an empty list if there was an error
    }
  }

  static void saveEventLocale(Event e) {
    AppEvents.savedEvents[e.code] = e;
    if (AppEvents.savedEventsCalendar
        .containsKey(DateUtils.dateOnly(DateTime.parse(e.initialDate)))) {
      AppEvents.savedEventsCalendar[DateUtils.dateOnly(
              DateUtils.dateOnly(DateTime.parse(e.initialDate)))]
          ?.add(e);
    } else {
      List<Event> l = [e];
      AppEvents.savedEventsCalendar[DateUtils.dateOnly(
          DateUtils.dateOnly(DateTime.parse(e.initialDate)))] = l;
    }
  }

  static void unsaveEventLocale(Event e) {
    if (AppEvents.savedEvents.containsKey(e.code)) {
      AppEvents.savedEvents.remove(e.code);
    }
    final eventsOnDate = AppEvents
        .savedEventsCalendar[DateUtils.dateOnly(DateTime.parse(e.initialDate))];
    if (eventsOnDate != null) {
      eventsOnDate.removeWhere((event) => event.code == e.code);
    }
  }

  static void saveEvent(String codeEvent) async {
    try {
      //save event
      await dio.post(
          'http://nattech.fib.upc.edu:40331/api/v1/users/saveEvent/$codeEvent');

      //cheking response
    } catch (error) {
      return;
    }
  }

  static void unsaveEvent(String codeEvent) async {
    try {
      //unsave event
      await dio.post(
          'http://nattech.fib.upc.edu:40331/api/v1/users/unsaveEvent/$codeEvent');

      //cheking response
    } catch (error) {
      return;
    }
  }

  static Future<Event> getEventByCode(String code) async {
    Event emptyEvent =
        Event("", "", "", "", "", "", "", "", "", "", "", "", "", []);
    try {
      //auth login for getting autorization
      await dio.post('http://nattech.fib.upc.edu:40331/api/v1/auth/login',
          data: {'email': 'cbum@gmail.com', 'password': 'cbumpostman'});
      //checking if event is saved
      final response =
          await dio.get('http://nattech.fib.upc.edu:40331/api/v1/events/$code');
      if (response.statusCode == 200) {
        String code;
        if (response.data['data']['code'] == null) {
          code = "";
        } else {
          code = response.data['data']['code'];
        }

        String denomination;
        if (response.data['data']['denomination'] == null) {
          denomination = "";
        } else {
          denomination = response.data['data']['denomination'];
        }

        String description;
        if (response.data['data']['description'] == null) {
          description = "";
        } else {
          description = response.data['data']['description'];
        }

        //images can be empty
        String image;
        if (response.data['data']['images'] == null) {
          image = "";
        } else {
          image = response.data['data']['images'][0];
        }

        //url can be null
        String url;
        if (response.data['data']['url'] == null) {
          url = "";
        } else {
          url = response.data['data']['url'];
        }

        String initD;
        if (response.data['data']['initial_date'] == null) {
          initD = "";
        } else {
          initD = response.data['data']['initial_date'];
        }

        String finalD;
        if (response.data['data']['final_date'] == null) {
          finalD = "";
        } else {
          finalD = response.data['data']['final_date'];
        }

        String schedule;
        if (response.data['data']['schedule'] == null) {
          schedule = "";
        } else {
          schedule = response.data['data']['schedule'];
        }

        String city;
        if (response.data['data']['region'] == null ||
            response.data['data']['region'].length < 3) {
          city = "";
        } else {
          city = response.data['data']['region'][2];
        }

        String adress;
        if (response.data['data']['address'] == null) {
          adress = "";
        } else {
          adress = response.data['data']['address'];
        }

        String tickets;
        if (response.data['data']['tickets'] == null) {
          tickets = "";
        } else {
          tickets = response.data['data']['tickets'];
        }

        String latitude;
        if (response.data['data']['latitude'] == null) {
          latitude = "";
        } else {
          latitude = response.data['data']['latitude'];
        }

        String longitude;
        if (response.data['data']['longitude'] == null) {
          longitude = "";
        } else {
          longitude = response.data['data']['longitude'];
        }
        List<dynamic> ambits = [];
        if (response.data['data']['ambits'] != null)
          ambits.addAll(response.data['data']['ambits']);

        Event event = Event(
            code,
            denomination,
            description,
            image,
            url,
            initD,
            finalD,
            schedule,
            city,
            adress,
            tickets,
            latitude,
            longitude,
            ambits);

        return event;
      } else
        return emptyEvent;
    } catch (error) {
      return emptyEvent;
    }
  }

  static Future<List<Event>> getEventsByAmbit(String ambit) async {
    try {
      List<Event> eventsByAmbit = [];

      final response = await dio.get(
          'http://nattech.fib.upc.edu:40331/api/v1/events/searchByAmbit?ambit=$ambit');
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          for (int i = 0; i < response.data['data'].length; ++i) {
            //response is already decoded.

            String denomination;
            if (response.data['data'][i]['denomination'] == null) {
              denomination = '';
            } else {
              denomination = response.data['data'][i]['denomination'];
            }

            String description;
            if (response.data['data'][i]['description'] == null) {
              description = '';
            } else {
              description = response.data['data'][i]['description'];
            }

            //images can be empty
            String image;
            if (response.data['data'][i]['images'] == null) {
              image = "";
            } else {
              image = response.data['data'][i]['images'][0];
            }

            //url can be null
            String url;
            if (response.data['data'][i]['url'] == null) {
              url = "";
            } else {
              url = response.data['data'][i]['url'];
            }

            String initD;
            if (response.data['data'][i]['initial_date'] == null) {
              initD = "";
            } else {
              initD = response.data['data'][i]['initial_date'];
            }

            String finalD;
            if (response.data['data'][i]['final_date'] == null) {
              finalD = "";
            } else {
              finalD = response.data['data'][i]['final_date'];
            }

            String schedule;
            if (response.data['data'][i]['schedule'] == null) {
              schedule = "";
            } else {
              schedule = response.data['data'][i]['schedule'];
            }

            String city;
            if (response.data['data'][i]['region'] == null ||
                response.data['data'][i]['region'].length < 3) {
              city = "";
            } else {
              city = response.data['data'][i]['region'][2];
            }

            String adress;
            if (response.data['data'][i]['address'] == null) {
              adress = "";
            } else {
              adress = response.data['data'][i]['address'];
            }

            String tickets;
            if (response.data['data'][i]['tickets'] == null) {
              tickets = "";
            } else {
              tickets = response.data['data'][i]['tickets'];
            }

            List<dynamic> ambits = [];
            if (response.data['data'][i]['ambits'] != null)
              ambits.addAll(response.data['data'][i]['ambits']);

            String latitude;
            if (response.data['data'][i]['latitude'] == null) {
              latitude = "";
            } else {
              latitude = response.data['data'][i]['latitude'];
            }

            String longitude;
            if (response.data['data'][i]['longitude'] == null) {
              longitude = "";
            } else {
              longitude = response.data['data'][i]['longitude'];
            }

            Event event = Event(
                response.data['data'][i]['code'],
                denomination,
                description,
                image,
                url,
                initD,
                finalD,
                schedule,
                city,
                adress,
                tickets,
                latitude,
                longitude,
                ambits);
            eventsByAmbit.add(event);
          }
          return eventsByAmbit;
        }
      }
      return [];
    } catch (error) {
      return [];
    }
  }

  static Future<String> existsSavedEvent(String codeEvent) async {
    try {
      //auth login for getting autorization
      await dio.post('http://nattech.fib.upc.edu:40331/api/v1/auth/login',
          data: {'email': 'cbum@gmail.com', 'password': 'cbumpostman'});
      //checking if event is saved
      final response = await dio.get(
          'http://nattech.fib.upc.edu:40331/api/v1/users/existSavedEvent/$codeEvent');
      if (response.data['exists'] != null) {
        return response.data['exists'];
      } else {
        return "";
      }
    } catch (error) {
      return "";
    }
  }

  static Future<List<String>> getAllAmbits() async {
    List<String> allAmbits = [];
    try {
      //request events
      final response =
          await dio.get('http://nattech.fib.upc.edu:40331/api/v1/ambits');

      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          for (int i = 0; i < response.data['data'].length; ++i) {
            //response is already decoded.
            allAmbits.add(response.data['data'][i]['name']);
          }
          return allAmbits;
        }
        return [];
      }
      return []; // return an empty list if there was an error
    } catch (error) {
      return []; // return an empty list if there was an error
    }
  }

  static String ObtainMessage(String title, String url) {
    if (url == "") {
      final eventname = title;
      return ("Check out this event! $eventname, this event doesn't have a link.");
    } else {
      return ("Check out this event found on CulturiCAT!\n$url , you can find more information about this event in the link");
    }
  }

  static void ShareAction(String message) {
    Share.share(message);
  }

  static Future<List<Event>> getEventsByDateRange(
      String initDate, String finalDate) async {
    try {
      List<Event> eventsByDataRange = [];

      final response = await dio.get(
          'http://nattech.fib.upc.edu:40331/api/v1/events/search?initial_date=$initDate&final_date=$finalDate');
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          for (int i = 0; i < response.data['data'].length; ++i) {
            //response is already decoded.

            String denomination;
            if (response.data['data'][i]['denomination'] == null) {
              denomination = '';
            } else {
              denomination = response.data['data'][i]['denomination'];
            }

            String description;
            if (response.data['data'][i]['description'] == null) {
              description = '';
            } else {
              description = response.data['data'][i]['description'];
            }

            //images can be empty
            String image;
            if (response.data['data'][i]['images'] == null) {
              image = "";
            } else {
              image = response.data['data'][i]['images'][0];
            }

            //url can be null
            String url;
            if (response.data['data'][i]['url'] == null) {
              url = "";
            } else {
              url = response.data['data'][i]['url'];
            }

            String initD;
            if (response.data['data'][i]['initial_date'] == null) {
              initD = "";
            } else {
              initD = response.data['data'][i]['initial_date'];
            }

            String finalD;
            if (response.data['data'][i]['final_date'] == null) {
              finalD = "";
            } else {
              finalD = response.data['data'][i]['final_date'];
            }

            String schedule;
            if (response.data['data'][i]['schedule'] == null) {
              schedule = "";
            } else {
              schedule = response.data['data'][i]['schedule'];
            }

            String city;
            if (response.data['data'][i]['region'] == null ||
                response.data['data'][i]['region'].length < 3) {
              city = "";
            } else {
              city = response.data['data'][i]['region'][2];
            }

            String adress;
            if (response.data['data'][i]['address'] == null) {
              adress = "";
            } else {
              adress = response.data['data'][i]['address'];
            }

            String tickets;
            if (response.data['data'][i]['tickets'] == null) {
              tickets = "";
            } else {
              tickets = response.data['data'][i]['tickets'];
            }

            List<dynamic> ambits = [];
            if (response.data['data'][i]['ambits'] != null)
              ambits.addAll(response.data['data'][i]['ambits']);

            String latitude;
            if (response.data['data'][i]['latitude'] == null) {
              latitude = "";
            } else {
              latitude = response.data['data'][i]['latitude'];
            }

            String longitude;
            if (response.data['data'][i]['longitude'] == null) {
              longitude = "";
            } else {
              longitude = response.data['data'][i]['longitude'];
            }

            Event event = Event(
                response.data['data'][i]['code'],
                denomination,
                description,
                image,
                url,
                initD,
                finalD,
                schedule,
                city,
                adress,
                tickets,
                latitude,
                longitude,
                ambits);
            eventsByDataRange.add(event);
          }
          return eventsByDataRange;
        }
      }
      return [];
    } catch (error) {
      return [];
    }
  }

  Future<int?> reportEvent(Event event, String category, String comment) async {
    Response response;
    dio.options.validateStatus = (status) {
      // Permitir el código de estado 400 como respuesta exitosa
      return status! < 405;
    };
    try {
      final id = User.id;
      switch (category) {
        case 'Assatjament':
          category = 'harassment';
          break;
        case 'Spam':
          category = 'spam';
          break;
        case 'Contingut inadequat':
          category = 'inappropriate content';
          break;
        case 'Discurs d\'odi':
          category = 'hate speech';
          break;
        case 'Informació falsa':
          category = 'false information';
          break;
        case 'Altres':
          category = 'other';
          break;
        default:
          category = 'other';
          break;
      }
      if (comment == '' || comment == null)
        comment = "L'usuari amb id: $id, no ha deixat cap comentari";
      final response = await dio.post(
        ReportApis.getReportEventUrl(event.code),
        data: {
          'type': category,
          'comment': comment,
        },
      );
      return response.statusCode;
    } catch (e) {
      return null;
    }
  }

  static Future<int> enviarFormulari(
    String formulari_name,
    String dataIni,
    String dataFi,
    String denomination_event,
    String description_event,
    String tickets_event,
    String schedule_event,
    List<String> ambits_event,
    String address_event,
    String postal_code_event,
    String email_event,
    String municipality_event,
    String url_event,
    String app_image_event,
  ) async {
    List<Location> locations = [];
    List<String> appImage = [app_image_event];
    try {
      String locationUnified =
          '$address_event, $postal_code_event ${municipality_event.toUpperCase()}';
      locations = await locationFromAddress(locationUnified);
    } catch (e) {
      return -4;
    }
    Response response;
    try {
      response = await dio
          .post('http://nattech.fib.upc.edu:40331/api/v1/formulari', data: {
        'formulari_name': formulari_name,
        'formulari_reason': ' ',
        'schedule_event': schedule_event,
        'user_id': User.id,
        'initial_d': dataIni.substring(0, dataIni.indexOf(' ')),
        'final_d': dataFi.substring(0, dataFi.indexOf(' ')),
        'initial_h':
            dataIni.substring(dataIni.lastIndexOf(' ') + 1, dataIni.length),
        'final_h': dataFi.substring(dataFi.lastIndexOf(' ') + 1, dataFi.length),
        'denomination_event': denomination_event,
        'description_event': description_event,
        'ambits_event': ambits_event,
        'address_event': address_event,
        'postal_code_event': postal_code_event,
        'email_event': email_event,
        'municipality_event': municipality_event,
        'latitude_event': locations.first.latitude,
        'longitude_event': locations.first.longitude,
        'url_event': url_event,
        'app_image_event': appImage
      });
    } catch (e) {
      return -2;
    }
    if (response.statusCode == 201) {
      Formulari f = Formulari(
          response.data['data']['formulari_name'],
          response.data['data']['denomination_event'],
          response.data['data']['formulari_status']);
      AppEvents.userForms.add(f);
      return 1;
    } else {
      return -1;
    }
  }

  static Future<List<Formulari>> getUserForms() async {
    List<Formulari> listReturn = [];
    Response r;
    try {
      r = await dio
          .get('http://nattech.fib.upc.edu:40331/api/v1/formulari/${User.id}');
    } catch (e) {
      return listReturn;
    }
    if (r.statusCode == 200) {
      if (r.data['data'] != null) {
        for (int i = 0; i < r.data['data'].length; ++i) {
          Formulari f = Formulari(
              r.data['data'][i]['formulari_name'],
              r.data['data'][i]['denomination_event'],
              r.data['data'][i]['formulari_status']);
          listReturn.add(f);
        }
      }
    }
    return listReturn;
  }

  static Future<List<Event>> getBestRatedEvents() async {
    try {
      List<Event> eventsByAmbit = [];

      final response = await dio
          .get('http://nattech.fib.upc.edu:40331/api/v1/events/best_rated');
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          for (int i = 0; i < response.data['data'].length; ++i) {
            //response is already decoded.

            String denomination;
            if (response.data['data'][i]['denomination'] == null) {
              denomination = '';
            } else {
              denomination = response.data['data'][i]['denomination'];
            }

            String description;
            if (response.data['data'][i]['description'] == null) {
              description = '';
            } else {
              description = response.data['data'][i]['description'];
            }

            //images can be empty
            String image;
            if (response.data['data'][i]['images'] == null) {
              image = "";
            } else {
              image = response.data['data'][i]['images'][0];
            }

            //url can be null
            String url;
            if (response.data['data'][i]['url'] == null) {
              url = "";
            } else {
              url = response.data['data'][i]['url'];
            }

            String initD;
            if (response.data['data'][i]['initial_date'] == null) {
              initD = "";
            } else {
              initD = response.data['data'][i]['initial_date'];
            }

            String finalD;
            if (response.data['data'][i]['final_date'] == null) {
              finalD = "";
            } else {
              finalD = response.data['data'][i]['final_date'];
            }

            String schedule;
            if (response.data['data'][i]['schedule'] == null) {
              schedule = "";
            } else {
              schedule = response.data['data'][i]['schedule'];
            }

            String city;
            if (response.data['data'][i]['region'] == null ||
                response.data['data'][i]['region'].length < 3) {
              city = "";
            } else {
              city = response.data['data'][i]['region'][2];
            }

            String adress;
            if (response.data['data'][i]['address'] == null) {
              adress = "";
            } else {
              adress = response.data['data'][i]['address'];
            }

            String tickets;
            if (response.data['data'][i]['tickets'] == null) {
              tickets = "";
            } else {
              tickets = response.data['data'][i]['tickets'];
            }

            List<dynamic> ambits = [];
            if (response.data['data'][i]['ambits'] != null)
              ambits.addAll(response.data['data'][i]['ambits']);

            String latitude;
            if (response.data['data'][i]['latitude'] == null) {
              latitude = "";
            } else {
              latitude = response.data['data'][i]['latitude'];
            }

            String longitude;
            if (response.data['data'][i]['longitude'] == null) {
              longitude = "";
            } else {
              longitude = response.data['data'][i]['longitude'];
            }

            Event event = Event(
                response.data['data'][i]['code'],
                denomination,
                description,
                image,
                url,
                initD,
                finalD,
                schedule,
                city,
                adress,
                tickets,
                latitude,
                longitude,
                ambits);
            eventsByAmbit.add(event);
          }
          return eventsByAmbit;
        }
      }
      return [];
    } catch (error) {
      return [];
    }
  }
}
