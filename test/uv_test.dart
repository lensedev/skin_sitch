import 'package:test/test.dart';
import 'package:skin_sitch/api/uv.dart' as uv;

void main() async {
  test('uv.dart.fetchUv() simple test', () {
    double lat = 44.9169;
    double lng = -93.3179;
    expect(
        uv.fetchUv(lat, lng).then((value) {
          print(value.now);
          print(value.forecast);
        }),
        completes);
  });
}
