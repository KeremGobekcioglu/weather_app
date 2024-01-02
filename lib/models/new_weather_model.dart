import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_api/services/location_helper.dart';

const apiKey = "19b50bbae6af153b984ac6840cb91315";

class WeatherData {
  WeatherData({required this.locationData});
  static const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  LocationHelper locationData;
  late int? temperature;
  late String? condition;

  Future<void> getCurrentTempandCond() async {
    final response = await http.get(Uri.parse(
        '$baseUrl?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      var currentWeather = jsonDecode(response.body);
      try {
        temperature = currentWeather['main']['temp'].toInt();
        condition = currentWeather['weather'][0]['main'];
      } catch (e) {
        print(e);
      }
    } else {
      print("Api calismiyor");
    }
  }
}
