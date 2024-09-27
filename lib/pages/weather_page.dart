import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meteo247/models/weather_model.dart';
import 'package:meteo247/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('3f25316e9d2fa4d12e679dc9184bae0e');
  Weather? _weather;

  // Fetch weather data
  Future<void> _fetchWeather() async {
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

  String translateCondition(String? condition) {
    switch (condition) {
      case 'Clear':
        return 'Ciel dégagé';
      case 'Clouds':
        return 'Nuageux';
      case 'Rain':
        return 'Pluie';
      case 'Snow':
        return 'Neige';
      case 'Thunderstorm':
        return 'Orage';
      case 'Fog':
        return 'Brouillard';
      case 'Mist':
        return 'Brouillard';
      default:
        return 'Chargement...';
    }
  }
  // Weather animations
 String getWeatherAnimation() {
    if (_weather == null) {
      return 'assets/loading.json';
    }

    switch (_weather!.mainCondition) {
      case 'Clear':
        return _weather!.isDay ? 'assets/sunny.json' : 'assets/moon.json';

      case 'Clouds':
        return _weather!.isDay
            ? 'assets/sunnycloudy.json'
            : 'assets/cloudynight.json';

      case 'Rain':
        return _weather!.isDay ? 'assets/rainy.json' : 'assets/rainynight.json';

      case 'Snow':
        return _weather!.isDay ? 'assets/snowy.json' : 'assets/rainynight.json';

      case 'Thunderstorm':
        return _weather!.isDay ? 'assets/rainy.json' : 'assets/rainynight.json';

      case 'Fog':
      case 'Mist':
        return 'assets/windy.json';

      default:
        return 'assets/loading.json';
    }
  }



  // Init state
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }
  
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(
            'assets/bg.jpg',
            fit: BoxFit.cover,
          ),
          ),
          Container(
            color: Colors.white60, 
          ),
          RefreshIndicator(
            onRefresh: _fetchWeather,
            child: Center(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      _weather?.cityName ?? 'Chargement de la ville...',
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold)
                    ),
                    Lottie.asset(
                      getWeatherAnimation(),
                      width: 250,
                      height: 250,
                    ),
                    Text(
                      '${_weather?.temperature.round() ?? ''}°C',
                      style: const TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                         ), 
                    ),
                    Text(
                      translateCondition(_weather?.mainCondition),
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
