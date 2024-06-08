import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GradientData {
  final List<double> stops;
  final List<Color> colors;

  GradientData(this.stops, this.colors) : assert(stops.length == colors.length);

  /*
  Method to determine the steps and colors to supply to belowBarData

  The problem is this: FL Chart's background doesn't allow a static gradient
  to be "revealed" by the line data, they only allow a solid color. To
  compensate, you can use a LinearGradient below the bar. However, it uses the
  bar's position to determine the start and end (0 and 1) positions for its
  stops. So if you want the gradient to remain "fixed" to the background graph,
  you need to calculate the interpolated value of the fixed steps in the context
  of the line. That lets you pretend to be using a fixed gradient, by only
  supplying some of the stops/colors to the bar area at a ratio determined by
  the max height of the line compared to the max value of the graph. This is 12
  regardless of actual display height of the graph, because the ratios
  themselves (found in the uvIndex class, for instance) are based on 12.

  If we want to make this applicable to other graphs with other Y axis values,
  we can do so by plugging in that ratio somewhere (or by supplying fixed
  values and calculating the ratio ourselves). Didn't feel important to do now.
  */
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
