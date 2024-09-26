class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final bool isDay; // New field to store whether it's day or night.

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.isDay, // Require this in the constructor.
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    // Get the current Unix time.
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Get sunrise and sunset times from the API response.
    int sunrise = json['sys']['sunrise'];
    int sunset = json['sys']['sunset'];

    // Determine if it's day or night.
    bool isDay = currentTime >= sunrise && currentTime < sunset;

    return Weather(
      cityName: json['name'],
      temperature: (json['main']['temp'] as num).toDouble(),
      mainCondition: json['weather'][0]['main'],
      isDay: isDay, // Pass the result of the day/night comparison.
    );
  }
}
