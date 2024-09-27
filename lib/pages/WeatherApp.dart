import 'package:flutter/material.dart';
import 'package:meteo247/models/weather_model.dart';
import 'package:meteo247/pages/Weather5day.dart';
import 'package:meteo247/pages/WeatherPage.dart';
import 'package:meteo247/services/weather_service.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final _weatherService = WeatherService('3f25316e9d2fa4d12e679dc9184bae0e');
  Weather? _weather;
  Map<String, List<Weather>> _forecast = {};
  final PageController _pageController = PageController();

  // Fetch weather data
  Future<void> _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      final position = await _weatherService.getCurrentPosition();
      final forecast = await _weatherService.get5DayForecast(position);

      setState(() {
        _weather = weather;
        _forecast = forecast;
      });
    } catch (e) {
      print(e);
    }
  }

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
          Container(
            decoration: const BoxDecoration(
              color: Colors.white
             /* image: DecorationImage(
                image: AssetImage('assets/bg.jpg'), 
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white54, BlendMode.lighten)
              ),*/
            ),
          ),
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: [
              // Weather Page
              Stack(
                children: [
                  WeatherPage(weather: _weather),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_pageController.page! < 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70,
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(
                        Icons.arrow_downward,
                        color: Colors.black, 
                      ),
                    ),
                  ),
                ],
              ),
              // Weather 5 Day Page
              Stack(
                children: [
                  Weather5day(forecast: _forecast),
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_pageController.page! > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70,
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
