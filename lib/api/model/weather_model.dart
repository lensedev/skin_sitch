// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Weather {
  int humidity;
  int temp;

  Weather({
    required this.humidity,
    required this.temp,
  });

  Weather copyWith({
    int? humidity,
    int? temp,
  }) {
    return Weather(
      humidity: humidity ?? this.humidity,
      temp: temp ?? this.temp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'humidity': humidity,
      'temp': temp,
    };
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      humidity: map['humidity'] as int,
      temp: map['temp'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Weather.fromJson(String source) =>
      Weather.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Weather(humidity: $humidity, temp: $temp)';

  @override
  bool operator ==(covariant Weather other) {
    if (identical(this, other)) return true;

    return other.humidity == humidity && other.temp == temp;
  }

  @override
  int get hashCode => humidity.hashCode ^ temp.hashCode;
}

class Grid {
  String cwa;
  int gridX;
  int gridY;

  Grid({
    required this.cwa,
    required this.gridX,
    required this.gridY,
  });

  Grid copyWith({
    String? cwa,
    int? gridX,
    int? gridY,
  }) {
    return Grid(
      cwa: cwa ?? this.cwa,
      gridX: gridX ?? this.gridX,
      gridY: gridY ?? this.gridY,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cwa': cwa,
      'gridX': gridX,
      'gridY': gridY,
    };
  }

  factory Grid.fromMap(Map<String, dynamic> map) {
    return Grid(
      cwa: map['cwa'] as String,
      gridX: map['gridX'] as int,
      gridY: map['gridY'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Grid.fromJson(String source) =>
      Grid.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Grid(cwa: $cwa, gridX: $gridX, gridY: $gridY)';

  @override
  bool operator ==(covariant Grid other) {
    if (identical(this, other)) return true;

    return other.cwa == cwa && other.gridX == gridX && other.gridY == gridY;
  }

  @override
  int get hashCode => cwa.hashCode ^ gridX.hashCode ^ gridY.hashCode;
}
