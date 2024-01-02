import "dart:async";
import 'package:shared_preferences/shared_preferences.dart';
import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "package:weather_api/models/new_weather_model.dart";
import "package:weather_api/services/location_helper.dart";

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});
  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  int? temp;
  String? cond;
  String? city;
  String? littlecity;
  int? old_temp;
  late LocationHelper locationHelper;
  late WeatherData weatherData;

  Future<void> getLocationData() async {
    locationHelper = LocationHelper();
    await locationHelper.getLocation();
    if (locationHelper.latitude == null || locationHelper.longitude == null) {
      print("İzin yok");
    }
  }

  String getWeatherAnimation(String? condition) {
    if (condition == null) return 'assets/null.json';
    switch (condition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunderstorm.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/snowy.json';
    }
  }

  Future<void> getWeatherdata() async {
    await getLocationData();
    final weatherData = WeatherData(locationData: locationHelper); // dikkat et
    await weatherData.getCurrentTempandCond();
    setState(() {
      temp = weatherData.temperature;
      cond = weatherData.condition;
      city = locationHelper.city!;
      littlecity = locationHelper.littlecity!;
    });
  }

  Timer? _timer;
  @override
  void initState() {
    super.initState();
    getLocationData();
    getWeatherdata();

    _timer = Timer.periodic(Duration(seconds: 15), (Timer timer) async {
      setState(() {
        old_temp = temp;
      });
      await getLocationData();
      await getWeatherdata();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // city name
              Column(
                children: [
                  Text(city ?? "loading city...",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Roboto",
                          color: Colors.grey[300])),
                  Text(littlecity ?? "loading littlecity...",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Roboto",
                          color: Colors.grey[300])),
                ],
              ),
              // null sa altta çizgi olan , olmayacak bişeyse karlı
              Lottie.asset(getWeatherAnimation(cond)),
              // temperaturer
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Previous : $temp°C",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto",
                        color: Colors.grey[200])),
                Text("Current : $temp°C",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto",
                        color: Colors.grey[200])),
                Text(cond ?? "loading weather...",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto",
                        color: Colors.grey[200])),
              ]),
            ],
          ),
        ));
  }
}
