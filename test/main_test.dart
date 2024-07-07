import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skin_sitch/api/location.dart';
import 'package:test/test.dart';
import 'package:skin_sitch/main.dart' as app;

String token = "mattdhoy@gmail.com";

class MockLocationUtility extends Mock implements LocationUtility {}

LocationUtility mlu = MockLocationUtility();

class MockPosition extends Mock implements Position {}

Position pos = MockPosition();

final GetIt injection = GetIt.instance;

void main() async {
  setUpAll(() {
    injection.registerSingleton<LocationUtility>(mlu);
    injection.registerSingleton<Position>(pos);
  });
  test('main.dart.fetchBreakdown() simple test', () {
    when(() => pos.latitude).thenReturn(44.9169);
    when(() => pos.longitude).thenReturn(-93.3179);
    when(mlu.determinePosition).thenAnswer((_) => Future(() => pos));
    expect(
        app.fetchBreakdown(token).then((result) {
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

  test('main.dart.roundUp() simple test', () {
    expect(app.roundUp(7.9), 8);
    expect(app.roundUp(8.1), 10);
    expect(app.roundUp(8.6), 10);
    expect(app.roundUp(9.1), 10);
    expect(app.roundUp(9.6), 10);
    expect(app.roundUp(10), 12);
  });
}
