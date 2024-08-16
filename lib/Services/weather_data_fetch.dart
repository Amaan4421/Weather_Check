import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {

  final String apiKey = '606e68786e4b44d2ad704520243007';
  
  Future getWeather(String city) async {
    final response = await http.get(
        Uri.parse('http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&aqi=no'));
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } 
    else 
    {
      print('Failed to load weather data: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load weather data!!!');
    }
  }

  Future getTimeData(String city) async {

    final localdate = DateTime.now().toIso8601String().split('T').first;
    
    final response = await http.get(
        Uri.parse('http://api.weatherapi.com/v1/astronomy.json?key=$apiKey&q=$city&dt=$localdate'));

    if(response.statusCode == 200) {
      return json.decode(response.body);
    }
    else
    {
      print('Failed to load weather data: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load sun time data!!!');
    }
  }

  Future getHourlyData(String city) async {

    final response = await http.get
        (Uri.parse('http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=1&aqi=no&alerts=no'));

    if(response.statusCode == 200) {
      var data = json.decode(response.body);
      print('Hourly Data: ${data['forecast']['forecastday'][0]['hour']}');
      return data;
    }
    else
    {
      print('Failed to load weather data: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load forcast data!!!');
    }
  }

  Future getWeeklyData(String city) async {

    final response = await http.get
        (Uri.parse('http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=7&aqi=no&alerts=no'));

    if(response.statusCode == 200) {
      var data = json.decode(response.body);
      print('Weekly Data: ${data['forecast']['forecastday']}');
      return data;
    }
    else
    {
      print('Failed to load weather data: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load forcast data!!!');
    }
  }
}
