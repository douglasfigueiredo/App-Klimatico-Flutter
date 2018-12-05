import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map> getWeather(String appId, String city) async {
  String apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$city&APPID=$appId&units=metric';

  http.Response response = await http.get(apiUrl);

  if (response.statusCode == 200 ) {
    return json.decode(response.body);
  } else {
    throw Exception("Falhou!");
  }
}