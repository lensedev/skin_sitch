import 'package:test/test.dart';
import 'package:skin_sitch/main.dart' as app;

String token = "mattdhoy@gmail.com";
double lat = 44.9169;
double lng = -93.3179;

void main() async {
  test('main.dart.fetchBreakdown() simple test', () {
    expect(
        app.fetchBreakdown(token, lat, lng).then((result) {
          expect(result.uvIndex.now.uvi, greaterThan(-1));
          expect(result.weather.temp, greaterThan(-50));
        }),
        completes);
  });

  test('main.dart.checkTime() simple test', () {
    final now = DateTime.now();
    final expired = now.subtract(const Duration(minutes: 6));
    final expiring = now.subtract(const Duration(minutes: 5));
    final notExpired = now.subtract(const Duration(minutes: 4));
    expect(app.timeExpired(now, expired), true);
    expect(app.timeExpired(now, expiring), true);
    expect(app.timeExpired(now, notExpired), false);
  });
}
