// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:geolocator/geolocator.dart';

import 'package:skin_sitch/api/model/uv_model.dart';
import 'package:skin_sitch/api/model/weather_model.dart';

class Breakdown {
  UVIndex uvIndex;
  Weather weather;
  Position position;

  Breakdown({
    required this.uvIndex,
    required this.weather,
    required this.position,
  });

  Breakdown copyWith({
    UVIndex? uvIndex,
    Weather? weather,
    Position? position,
  }) {
    return Breakdown(
      uvIndex: uvIndex ?? this.uvIndex,
      weather: weather ?? this.weather,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uvIndex': uvIndex.toMap(),
      'weather': weather.toMap(),
      'position': position.toJson(),
    };
  }

  factory Breakdown.fromMap(Map<String, dynamic> map) {
    return Breakdown(
      uvIndex: UVIndex.fromMap(map['uvIndex'] as Map<String, dynamic>),
      weather: Weather.fromMap(map['weather'] as Map<String, dynamic>),
      position: Position.fromMap(map['position'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Breakdown.fromJson(String source) =>
      Breakdown.fromMap(json.decode(source) as Map<String, dynamic>);

  double getUvUpperBound() {
    double maxUv = uvIndex.now.uvi;
    for (int i = 0; i < 24; i++) {
      maxUv = max(maxUv, uvIndex.forecast[i].uvi);
    }
    return maxUv;
  }

  @override
  String toString() =>
      'Breakdown(uvIndex: $uvIndex, weather: $weather, position: $position)';

  @override
  bool operator ==(covariant Breakdown other) {
    if (identical(this, other)) return true;

    return other.uvIndex == uvIndex &&
        other.weather == weather &&
        other.position == position;
  }

  @override
  int get hashCode => uvIndex.hashCode ^ weather.hashCode ^ position.hashCode;
}
