import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skin_sitch/api/gradient.dart';

void main() async {
  test("GradientData Constructor tests", () {
    expect(() => GradientData([0], [Colors.black, Colors.blue]),
        throwsAssertionError);
    expect(() => GradientData([0, 1, 2], [Colors.black, Colors.blue]),
        throwsAssertionError);
    expect(() => GradientData([0], [Colors.black]), returnsNormally);
  });

  test("GradientData.getRelativeGradient() simple test", () {
    final data = GradientData([
      0,
      0.5,
      1,
    ], [
      Colors.green,
      Colors.yellow,
      Colors.red,
    ]);

    final modded = data.getRelativeGradient(8, 12); // ratio == 1.5
    expect(modded.stops, [0.0, 0.75, 1.0]);
    expect(modded.colors, [Colors.green, Colors.yellow, Colors.red]);
  });
}
