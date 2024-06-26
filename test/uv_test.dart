import 'package:fl_chart/fl_chart.dart';
import 'package:skin_sitch/api/model/uv_model.dart';
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
    expect(getMaxSpot(spots), 14);
    spots.add(const FlSpot(15, 15));
    expect(getMaxSpot(spots), 15);
  });
}
