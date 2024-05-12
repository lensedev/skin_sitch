import 'package:skin_sitch/api/model/weather_model.dart';
import 'package:test/test.dart';
import 'package:skin_sitch/api/weather.dart' as weather;

Grid sample = Grid(cwa: "MPX", gridX: 107, gridY: 69);
String token = "mattdhoy@gmail.com";

void main() async {
  test('weather.dart.fetchZone() simple test', () {
    double lat = 44.9169;
    double lng = -93.3179;
    expect(
        weather.fetchZone(token, lat, lng).then((value) {
          expect(value, sample);
        }),
        completes);
  });
  test('weather.dart.fetchWeather() simple test', () {
    expect(
        weather.fetchWeather(token, sample).then((value) {
          expect(value.temp, greaterThan(-50));
          expect(value.humidity, greaterThan(-10));
        }),
        completes);
  });
}
