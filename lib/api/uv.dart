import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'model/uv_model.dart';

Future<UVIndex> fetchUv(final double lat, final double lng) async {
  final url = Uri.parse(
      "https://currentuvindex.com/api/v1/uvi?latitude=$lat&longitude=$lng");
  Response response = await http.get(url);
  final body = jsonDecode(response.body);
  return UVIndex.fromMap(body);
}
