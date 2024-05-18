import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'model/weather_model.dart';

Future<Grid> fetchZone(String token, double lat, double lng) async {
  final url = Uri.parse("https://api.weather.gov/points/$lat,$lng");
  final Map<String, String> headers = {
    "User-Agent": token,
  };
  Response response = await http.get(
    url,
    headers: headers,
  );
  final body = jsonDecode(response.body)['properties'];
  return Grid(
    cwa: body['cwa'],
    gridX: body['gridX'],
    gridY: body['gridY'],
  );
}

Future<Weather> fetchWeather(String token, Grid grid) async {
  final url = Uri.parse(
      "https://api.weather.gov/gridpoints/${grid.cwa}/${grid.gridX},${grid.gridY}/forecast/hourly");
  final Map<String, String> headers = {
    "User-Agent": token,
  };
  Response response = await http.get(
    url,
    headers: headers,
  );
  final period = jsonDecode(response.body)['properties']["periods"][0];
  return Weather(
      humidity: period['relativeHumidity']['value'],
      temp: period["temperature"]);
}
