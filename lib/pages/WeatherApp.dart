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
  final _weatherService = WeatherService('65ca9262ff9f70b556c2ae208f510de9');
  Weather? _weather;
  Map<String, List<Weather>> _forecast = {};
  final PageController _pageController = PageController();
  bool _isDarkMode = false;

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
        _isDarkMode =
            !weather.isDay; // Set dark mode based on current day/night
      });
    } catch (e) {
      print(e);
    }
  }

  // Refresh weather data
  Future<void> _refreshWeather() async {
    await _fetchWeather();
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode; // Allow manual theme toggling
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              color: _isDarkMode ? Colors.black : Colors.white,
            ),
            RefreshIndicator(
              onRefresh: _refreshWeather,
              child: PageView(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                children: [
                  // Weather Page
                  Stack(
                    children: [
                      WeatherPage(
                        weather: _weather,
                        isDarkMode: _isDarkMode,
                        isDay: _weather?.isDay ?? true,
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: IconButton(
                          icon: Icon(
                            _isDarkMode ? Icons.wb_sunny : Icons.nights_stay,
                            color: _isDarkMode ? Colors.white : Colors.black,
                            size: 50,
                          ),
                          onPressed: _toggleTheme,
                        ),
                      ),
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
            ),
          ],
        ),
      ),
    );
  }
}
