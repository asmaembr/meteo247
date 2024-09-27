class Weather {
  final String? cityName; 
  final double temperature;
  final String mainCondition;
  final bool isDay;
  final DateTime date;

   Weather({
    required this.temperature,
    required this.mainCondition,
    required this.isDay,
    required this.date,
    this.cityName,
  });
  factory Weather.fromJson(Map<String, dynamic> json) {
    
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int sunrise = json['sys']['sunrise'];
    int sunset = json['sys']['sunset'];
    bool isDay = currentTime >= sunrise && currentTime < sunset;

    return Weather(
      cityName: json['name'],
      temperature: (json['main']['temp'] as num).toDouble(),
      mainCondition: json['weather'][0]['main'],
      isDay: isDay, 
      date: DateTime.now(),
    );
  }
    // For 5-day forecast data
  factory Weather.fromForecastJson(Map<String, dynamic> json) {
    return Weather(
      cityName: null, // cityName might not be available in the forecast data
      temperature: (json['main']['temp'] as num)
          .toDouble(), // Adjust for 3-hour intervals, not daily
      mainCondition: json['weather'][0]['main'],
      isDay: true, // Assume day, or add logic based on forecast time (optional)
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }
}
