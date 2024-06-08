import 'package:fl_chart/fl_chart.dart';
import 'package:test/test.dart';
import 'package:skin_sitch/api/uv.dart' as uv;

void main() async {
  test('uv.dart.fetchUv() simple test', () {
    double lat = 44.9169;
    double lng = -93.3179;
    expect(uv.fetchUv(lat, lng), completes);
  });

  test('uv.dart.getMaxSpot() simple test', () {
    var spots = <FlSpot>[];
    for (var i = 0; i < 15; i++) {
      spots.add(FlSpot(i.toDouble(), i.toDouble()));
    }
  });
}
