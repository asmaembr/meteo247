import 'package:flutter/material.dart';
import 'package:meteo247/models/weather_model.dart';
import 'package:meteo247/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService('3f25316e9d2fa4d12e679dc9184bae0e');
  Weather? _weather;
  // fetch weather
  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }
  //weather animations

  //init state
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? 'Chargement de la ville...'),
            Text('${_weather?.temperature.round()}°C'),
          ],
        ),
      ),
    );
  }
}
