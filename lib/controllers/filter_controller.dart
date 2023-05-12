import 'dart:async';
import '../APIs/ambit_apis.dart';

import 'package:http/http.dart' as http;


class FilterController {  

  Future<List<String>> getFilters() async {
    
    await
    http.post(
      Uri.parse(AmbitsApis.getAllAmbitsUrl()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
    },

    );
    return ['Data', 'Hora', 'Localització', 'Prueba', 'Prueba2', 'Prueba3'];
  }
}