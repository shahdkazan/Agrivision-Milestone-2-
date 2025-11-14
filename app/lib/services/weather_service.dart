class WeatherService {
  // Fetch weather for a location
  Future<Map<String, dynamic>> getWeather(double lat, double lon) async => {};
}

class LocationService {
  // Get current GPS location
  Future<Map<String, double>> getCurrentLocation() async => {};
}

class AlertService {
  // Trigger alert
  Future<void> triggerAlert(String message) async {}
}
