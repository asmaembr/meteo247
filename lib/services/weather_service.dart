import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:meteo247/models/weather_model.dart';

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5';
  final String apiKey;

  WeatherService(this.apiKey);

//get the weather data for a city
  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/weather?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Échec du chargement des données météo');
    }
  }

// 5-day forecast
  Future<Map<String, List<Weather>>> get5DayForecast(Position position) async {
    final response = await http.get(
      Uri.parse(
        '$BASE_URL/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric',
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> forecastList = jsonDecode(response.body)['list'];
      Map<String, List<Weather>> dailyForecasts = {};

      for (var item in forecastList) {
        // Extract the date as a string (e.g., "2024-09-27")
        String date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000)
            .toLocal()
            .toIso8601String()
            .split('T')[0];

        // Create Weather object for each hourly forecast
        Weather weather = Weather.fromForecastJson(item);

        // Add weather to the corresponding day's list
        if (!dailyForecasts.containsKey(date)) {
          dailyForecasts[date] = [];
        }
        dailyForecasts[date]!.add(weather);
      }

      return dailyForecasts; // Return a map of day and list of Weather objects
    } else {
      throw Exception('Failed to load the 5-day weather forecast');
    }
  }



//get the city name
  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String? city = placemarks[0].locality;
    return city ?? "";
  }

//position without the city name
  Future<Position> getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
