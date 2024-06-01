import 'package:flutter/material.dart';
import 'package:skin_sitch/api/model/model.dart';
import 'package:skin_sitch/api/uv.dart';
import 'package:skin_sitch/api/weather.dart';
import 'package:geolocator/geolocator.dart';

const applySunscreen = "Use sunscreen!";
const expiryTime = 5;

void main() {
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
                      future: fetchBreakdown(
                          "mattdhoy@gmail.com", 44.9169, -93.3179),
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
                            return displayInfo(_breakdown.uvIndex.now.uvi,
                                _breakdown.weather.humidity, context);
                          } else {
                            return Center(
                              child: Text(
                                "Something went wrong",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            );
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }));
                } else {
                  return displayInfo(_breakdown.uvIndex.now.uvi,
                      _breakdown.weather.humidity, context);
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}

Center displayInfo(final double currentUVI, final int currentHumidity,
    final BuildContext context) {
  return Center(
      child: Column(
    children: [
      displayUvIndexIcon(currentUVI, context), // change for EUT
      const Padding(padding: EdgeInsets.all(2.0)),
      readOutUVIndex(currentUVI), // change for EUT
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
  // TODO: Consider Enum of UVI for unified selection
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
    return _formatUVIndexReadOut(
        const Color.fromARGB(255, 89, 228, 35), currentUVI, "Safe in the sun!");
  } else if (1 <= currentUVI && currentUVI < 2.5) {
    return _formatUVIndexReadOut(
        const Color.fromARGB(255, 157, 197, 1), currentUVI, applySunscreen);
  } else if (2.5 <= currentUVI && currentUVI < 5.5) {
    return _formatUVIndexReadOut(
        const Color.fromARGB(255, 255, 206, 0), currentUVI, applySunscreen);
  } else if (5.5 <= currentUVI && currentUVI < 7.5) {
    return _formatUVIndexReadOut(
        const Color.fromARGB(255, 254, 128, 0), currentUVI, applySunscreen);
  } else if (7.5 <= currentUVI && currentUVI < 10.5) {
    return _formatUVIndexReadOut(const Color.fromARGB(255, 245, 81, 37),
        currentUVI, "Very high UV, limit exposure!");
  } else {
    return _formatUVIndexReadOut(
        const Color.fromARGB(255, 158, 70, 205), currentUVI, "Remain indoors!");
  }
}

Future<Breakdown> fetchBreakdown(
    final String token, final double lat, final double lng) async {
  return Breakdown(
      uvIndex: await fetchUv(lat, lng),
      weather: await fetchWeather(token, await fetchZone(token, lat, lng)));
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
