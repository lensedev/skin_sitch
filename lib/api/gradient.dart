import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GradientData {
  final List<double> stops;
  final List<Color> colors;

  GradientData(this.stops, this.colors) : assert(stops.length == colors.length);

  GradientData getRelativeGradient(final num dataYMax, final num graphYMax) {
    final double ratio = graphYMax / dataYMax;
    List<double> newStops = <double>[];
    List<Color> newColors = <Color>[];
    var lastIndex = 0;
    for (var i = 0; i < stops.length - 1; i++) {
      double mult = stops[i] * ratio;
      if (mult < 1) {
        newStops.add(mult);
        newColors.add(colors[i]);
        lastIndex = i;
      }
    }
    newStops.add(1);
    newColors.add(colors[lastIndex + 1]);
    return GradientData(newStops, newColors);
  }
}

BarAreaData createBarAreaData(
  final double maxY,
  final List<double> stops,
  final List<Color> colors,
) {
  final canvasGradientData = GradientData(stops, colors);
  final underGradientData = canvasGradientData.getRelativeGradient(maxY, 12);
  return BarAreaData(
    show: true,
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      stops: underGradientData.stops,
      colors: underGradientData.colors,
    ),
  );
}
