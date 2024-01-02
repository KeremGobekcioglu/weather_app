import "dart:convert";

import "package:geocoding/geocoding.dart";
import "package:geolocator/geolocator.dart";
import "package:weather_api/models/wearher_model.dart";
import "package:http/http.dart" as http;

class WeatherService {
  static const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey = "19b50bbae6af153b984ac6840cb91315";
  String? latitute;
  String? longtitude;

  WeatherService();

  // This function is asynchronous and returns a Future that completes with a Weather object.
  Future<Weather> getWeather(String cityName) async {
    // Send a GET request to the weather API with the specified city name.
    final response = await http
        .get(Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'));

    // Check if the request was successful.
    if (response.statusCode == 200) {
      // Use the factory constructor `fromJson` to create a Weather object from the JSON response.
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error fetching weather for location');
    }
  }

  Future<String> getCurrencity() async {
    // get permission from the user
    LocationPermission permission = await Geolocator.requestPermission();
    // requesting the permission again
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    // fetching the current location
    Position position = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
        desiredAccuracy: LocationAccuracy.medium);

    // converting the location into a list of placemarks
    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude); // dikkat et
    latitute = position.latitude.toString();
    longtitude = position.longitude.toString();

    // extract the city name from the first placemark in the list
    String? city = placemarks[0].locality;

    // return the city name, or an empty string if no city name is found
    return city ?? "";
  }
}
