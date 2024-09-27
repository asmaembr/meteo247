import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meteo247/models/weather_model.dart';

class WeatherPage extends StatelessWidget {
  final Weather? weather;

  const WeatherPage({super.key, required this.weather});

  // Weather animations
  String getWeatherAnimation(Weather? weather) {
    if (weather == null) {
      return 'assets/loading.json';
    }

    switch (weather.mainCondition) {
      case 'Clear':
        return weather.isDay ? 'assets/sunny.json' : 'assets/moon.json';
      case 'Clouds':
        return weather.isDay
            ? 'assets/sunnycloudy.json'
            : 'assets/cloudynight.json';
      case 'Rain':
        return weather.isDay ? 'assets/rainy.json' : 'assets/rainynight.json';
      case 'Snow':
        return weather.isDay ? 'assets/snowy.json' : 'assets/rainynight.json';
      case 'Thunderstorm':
        return weather.isDay ? 'assets/rainy.json' : 'assets/rainynight.json';
      case 'Fog':
      case 'Mist':
        return 'assets/windy.json';
      default:
        return 'assets/loading.json';
    }
  }

  // Translate the weather condition
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
      case 'Mist':
        return 'Brouillard';
      default:
        return 'Chargement...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weather?.cityName ?? 'Chargement de la ville...',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Lottie.asset(getWeatherAnimation(weather), height: 250),
          Text(
            '${weather?.temperature.round() ?? ''}°C',
            style: const TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            translateCondition(weather?.mainCondition),
            style: const TextStyle(
              fontSize: 25,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
