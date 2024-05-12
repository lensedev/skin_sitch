// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class UVIndex {
  TimeCast now;
  List<TimeCast> forecast;

  UVIndex({
    required this.now,
    required this.forecast,
  });

  UVIndex copyWith({
    TimeCast? now,
    List<TimeCast>? forecast,
  }) {
    return UVIndex(
      now: now ?? this.now,
      forecast: forecast ?? this.forecast,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'now': now.toMap(),
      'forecast': forecast.map((x) => x.toMap()).toList(),
    };
  }

  factory UVIndex.fromMap(Map<String, dynamic> map) {
    return UVIndex(
      now: TimeCast.fromMap(map['now'] as Map<String, dynamic>),
      forecast: List<TimeCast>.from(
        (map['forecast'] as List<dynamic>).map<TimeCast>(
          (x) => TimeCast.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UVIndex.fromJson(String source) =>
      UVIndex.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UVIndex(now: $now, forecast: $forecast)';

  @override
  bool operator ==(covariant UVIndex other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.now == now && listEquals(other.forecast, forecast);
  }

  @override
  int get hashCode => now.hashCode ^ forecast.hashCode;
}

class TimeCast {
  DateTime time;
  double uvi;

  TimeCast({
    required this.time,
    required this.uvi,
  });

  TimeCast copyWith({
    DateTime? time,
    double? uvi,
  }) {
    return TimeCast(
      time: time ?? this.time,
      uvi: uvi ?? this.uvi,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'time': time.millisecondsSinceEpoch,
      'uvi': uvi,
    };
  }

  factory TimeCast.fromMap(Map<String, dynamic> map) {
    return TimeCast(
      time: DateTime.parse(map['time'] as String),
      uvi: map['uvi'].toDouble() as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeCast.fromJson(String source) =>
      TimeCast.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TimeCast(time: $time, uvi: $uvi)';

  @override
  bool operator ==(covariant TimeCast other) {
    if (identical(this, other)) return true;

    return other.time == time && other.uvi == uvi;
  }

  @override
  int get hashCode => time.hashCode ^ uvi.hashCode;
}
