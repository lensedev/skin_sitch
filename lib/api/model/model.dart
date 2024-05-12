// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:skin_sitch/api/model/uv_model.dart';
import 'package:skin_sitch/api/model/weather_model.dart';

class Breakdown {
  UVIndex uvIndex;
  Weather weather;

  Breakdown({
    required this.uvIndex,
    required this.weather,
  });

  Breakdown copyWith({
    UVIndex? uvIndex,
    Weather? weather,
  }) {
    return Breakdown(
      uvIndex: uvIndex ?? this.uvIndex,
      weather: weather ?? this.weather,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uvIndex': uvIndex.toMap(),
      'weather': weather.toMap(),
    };
  }

  factory Breakdown.fromMap(Map<String, dynamic> map) {
    return Breakdown(
      uvIndex: UVIndex.fromMap(map['uvIndex'] as Map<String, dynamic>),
      weather: Weather.fromMap(map['weather'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Breakdown.fromJson(String source) =>
      Breakdown.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Breakdown(uvIndex: $uvIndex, weather: $weather)';

  @override
  bool operator ==(covariant Breakdown other) {
    if (identical(this, other)) return true;

    return other.uvIndex == uvIndex && other.weather == weather;
  }

  @override
  int get hashCode => uvIndex.hashCode ^ weather.hashCode;
}
