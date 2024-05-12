import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'model/uv_model.dart';

Future<UVIndex> fetchUv(double lat, double lng) async {
  final url = Uri.parse(
      "https://currentuvindex.com/api/v1/uvi?latitude=$lat&longitude=$lng");
  Response response = await http.get(url);
  final body = jsonDecode(response.body);
  return UVIndex.fromMap(body);
}
