import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';

import 'api/location.dart';
import 'api/model/model.dart';
import 'api/uv.dart';
import 'api/weather.dart';

final GetIt injection = GetIt.instance;

const String applySunscreen = "Use sunscreen!";
const int expiryTime = 5;
const Color safeGreen = Color.fromARGB(255, 89, 228, 35);
const Color transitionGreen = Color.fromARGB(255, 157, 197, 1);
const Color dangerYellow = Color.fromARGB(255, 255, 206, 0);
const Color dangerOrange = Color.fromARGB(255, 254, 128, 0);
const Color dangerRed = Color.fromARGB(255, 245, 81, 37);
const Color dangerPurple = Color.fromARGB(255, 158, 70, 205);
const Map<int, String> times = {
  0: "12AM",
  1: "1AM",
  2: "2AM",
  3: "3AM",
  4: "4AM",
  5: "5AM",
  6: "6AM",
  7: "7AM",
  8: "8AM",
  9: "9AM",
  10: "10AM",
  11: "11AM",
  12: "12PM",
  13: "1PM",
  14: "2PM",
  15: "3PM",
  16: "4PM",
  17: "5PM",
  18: "6PM",
  19: "7PM",
  20: "8PM",
  21: "9PM",
  22: "10PM",
  23: "11PM",
};

void main() {
  injection.registerSingleton<LocationUtility>(LocationUtility());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skin Sitch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Skin Sitch'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _runOnce = false;
  DateTime _current = DateTime.now();
  late Breakdown _breakdown;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          top: true,
          child: Column(
            children: <Widget>[
              Builder(builder: (context) {
                if (!_runOnce || timeExpired(DateTime.now(), _current)) {
                  return FutureBuilder(
                      future: fetchBreakdown("mattdhoy@gmail.com"),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                '${snapshot.error} occurred',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            );
                          } else if (snapshot.hasData) {
                            _runOnce = true;
                            _breakdown = snapshot.data as Breakdown;
                            _current = DateTime.now();
                            return displayInfo(_breakdown, context);
                          } else {
                            return Center(
                              child: Text(
                                "Something went wrong",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            );
                          }
                        } else if (_runOnce) {
                          return displayInfo(_breakdown, context);
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }));
                } else {
                  return displayInfo(_breakdown, context);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

Center displayInfo(final Breakdown breakdown, final BuildContext context) {
  return Center(
      child: Column(
    children: [
      const Padding(padding: EdgeInsets.all(2.0)),
      displayUvIndexIcon(breakdown.uvIndex.now.uvi, context), // change for EUT
      const Padding(padding: EdgeInsets.all(5.0)),
      readOutUVIndex(breakdown.uvIndex.now.uvi), // change for EUT
      const Padding(padding: EdgeInsets.all(5.0)),
      Center(
          child: AspectRatio(
        aspectRatio: 2.0,
        child: LineChart(LineChartData(
          gridData: const FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 2,
            verticalInterval: 4,
          ),
          titlesData: FlTitlesData(
              topTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 23,
                getTitlesWidget: (value, meta) => const Text(""),
              )),
              rightTitles: const AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                interval: 2,
              )),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  interval: 4,
                  getTitlesWidget: (value, meta) {
                    var hourCalc = (DateTime.now().hour + value) % 24;
                    String hour = times[hourCalc] ?? "12AM";
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(hour),
                    );
                    // child: Text("$value"));
                  },
                  showTitles: true,
                  reservedSize: 23,
                ),
              ),
              leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                interval: 2,
              ))),
          maxY: roundUp(breakdown.getUvUpperBound()),
          lineBarsData: [
            breakdown.uvIndex.readForecast(24),
          ],
        )),
      ))
    ],
  ));
}

Row displayUvIndexIcon(final double currentUVI, final BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      selectUvIndexImage(currentUVI),
    ],
  );
}

Image _formatUVIndexImage(final String asset) {
  return Image.asset(
    asset,
    height: 200,
    scale: 1,
  );
}

Image selectUvIndexImage(final double currentUVI) {
  if (currentUVI < 1) {
    return _formatUVIndexImage('assets/images/UV-0.png');
  } else if (1 <= currentUVI && currentUVI < 2.5) {
    return _formatUVIndexImage('assets/images/UV-1-2.png');
  } else if (2.5 <= currentUVI && currentUVI < 5.5) {
    return _formatUVIndexImage('assets/images/UV-3-5.png');
  } else if (5.5 <= currentUVI && currentUVI < 7.5) {
    return _formatUVIndexImage('assets/images/UV-6-7.png');
  } else if (7.5 <= currentUVI && currentUVI < 10.5) {
    return _formatUVIndexImage('assets/images/UV-8-10.png');
  } else {
    return _formatUVIndexImage('assets/images/UV-11+.png');
  }
}

Column _formatUVIndexReadOut(
    Color color, final double currentUVI, final String message) {
  return Column(
    children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            height: 75,
            width: 150,
            color: color,
            child: Center(
                child: Text(
              "$currentUVI",
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 54,
                fontWeight: FontWeight.bold,
              ),
            )),
          )),
      const Padding(padding: EdgeInsets.all(3.0)),
      Text(
        message,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Column readOutUVIndex(final double currentUVI) {
  if (currentUVI < 1) {
    return _formatUVIndexReadOut(safeGreen, currentUVI, "Safe in the sun!");
  } else if (1 <= currentUVI && currentUVI < 2.5) {
    return _formatUVIndexReadOut(transitionGreen, currentUVI, applySunscreen);
  } else if (2.5 <= currentUVI && currentUVI < 5.5) {
    return _formatUVIndexReadOut(dangerYellow, currentUVI, applySunscreen);
  } else if (5.5 <= currentUVI && currentUVI < 7.5) {
    return _formatUVIndexReadOut(dangerOrange, currentUVI, applySunscreen);
  } else if (7.5 <= currentUVI && currentUVI < 10.5) {
    return _formatUVIndexReadOut(
        dangerRed, currentUVI, "Very high UV, limit exposure!");
  } else {
    return _formatUVIndexReadOut(dangerPurple, currentUVI, "Remain indoors!");
  }
}

Future<Breakdown> fetchBreakdown(final String token) async {
  // TODO: Handle use case where they do not allow
  Position position =
      await injection.get<LocationUtility>().determinePosition();
  return Breakdown(
      uvIndex: await fetchUv(position.latitude, position.longitude),
      weather: await fetchWeather(
          token, await fetchZone(token, position.latitude, position.longitude)),
      position: position);
}

bool timeExpired(final DateTime now, final DateTime comp) {
  DateTime expiry = comp.add(const Duration(minutes: expiryTime));
  /*
  The three potential results are:
    * a negative value if expiry isBefore now; i.e. expired
    * 0 if expiry isAtSameMomentAs now; i.e. expiring
    * a positive value if expiry isAfter now; i.e. not yet expired
  */
  if (expiry.compareTo(now) <= 0) {
    return true;
  } else {
    return false;
  }
}

double roundUp(final double input) {
  var rounded = (input + 0.5).round();
  if (rounded % 2 == 1) {
    return (rounded + 1).toDouble();
  }
  return rounded.toDouble();
}
