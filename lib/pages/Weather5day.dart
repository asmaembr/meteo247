import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meteo247/models/weather_model.dart'; // Import your Weather model

class Weather5day extends StatelessWidget {
  final Map<String, List<Weather>> forecast;

  const Weather5day({super.key, required this.forecast});

  // Translate the weather condition for the forecast
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

  // Weather animations for 5-day forecast
  String getWeatherAnimationForForecast(Weather weather) {
    // Determine if it's day or night based on the hour
    int hour = weather.date.hour;
    bool isDaytime = hour >= 6 && hour < 21; 

    switch (weather.mainCondition) {
      case 'Clear':
        return isDaytime ? 'assets/sunny.json' : 'assets/moon.json';
      case 'Clouds':
        return isDaytime
            ? 'assets/sunnycloudy.json'
            : 'assets/cloudynight.json';
      case 'Rain':
        return isDaytime ? 'assets/rainy.json' : 'assets/rainynight.json';
      case 'Snow':
        return isDaytime ? 'assets/snowy.json' : 'assets/snowynight.json';
      case 'Thunderstorm':
        return isDaytime ? 'assets/rainy.json' : 'assets/rainynight.json';
      case 'Fog':
      case 'Mist':
        return 'assets/windy.json';
      default:
        return 'assets/loading.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 70),
          ...forecast.entries.map((entry) {
            String date = entry.key;
            List<Weather> dailyWeather = entry.value;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dailyWeather.length,
                      itemBuilder: (context, hourIndex) {
                        Weather hourlyWeather = dailyWeather[hourIndex];
                        return Container(
                          width: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${hourlyWeather.date.hour}:00',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Lottie.asset(
                                getWeatherAnimationForForecast(hourlyWeather),
                                height: 70,
                              ),
                              Text(
                                '${hourlyWeather.temperature.round()}°C',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                translateCondition(hourlyWeather.mainCondition),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(
                      height: 30,  thickness: 2),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
