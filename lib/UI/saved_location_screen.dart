import 'package:flutter/material.dart';
import 'package:weather_check/Services/weather_data_fetch.dart';
import 'add_city_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedLocationsScreen extends StatefulWidget {
  const SavedLocationsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SavedLocationsScreenState createState() => _SavedLocationsScreenState();
}

class _SavedLocationsScreenState extends State<SavedLocationsScreen> {

  List<String> savedCities = [];
  Map<String, Map<String, dynamic>> cityWeatherData = {};

 @override
  void initState() {
    super.initState();
    _loadSavedCities();
  }

  Future<void> _loadSavedCities() async {
    final prefs = await SharedPreferences.getInstance();
    final cityList = prefs.getStringList('savedCities') ?? [];
    setState(() {
      savedCities = cityList;
    });
    fetchWeatherForAllCities();
  }

  Future<void> _saveCities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('savedCities', savedCities);
  }

  Future<void> fetchWeatherForAllCities() async {
    for (var city in savedCities) {
      try {
        var weatherData = await WeatherService().getWeather(city);
        setState(() {
          cityWeatherData[city] = weatherData;
        });
      } catch (e) {
        print('Failed to fetch weather for $city: $e');
      }
    }
  }

  void _openAddCityScreen() async {
    final newCity = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCityScreen(
          onCityAdded: (cityName) {
            setState(() {
              if (!savedCities.contains(cityName)) {
                savedCities.add(cityName);
                cityWeatherData[cityName] = {};
              }
            });
            _saveCities();
            fetchWeatherForAllCities();
          },
        ),
      ),
    );

    if (newCity != null && newCity is String && !savedCities.contains(newCity)) {
      setState(() {
        savedCities.add(newCity);
        cityWeatherData[newCity] = {};
      });
      _saveCities();
      fetchWeatherForAllCities();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Locations',
          style: TextStyle(fontWeight: FontWeight.bold),
          ),
        backgroundColor: const Color.fromARGB(255, 39, 116, 107),
      ),
      backgroundColor: const Color.fromARGB(255, 153, 250, 233),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: savedCities.length,
              itemBuilder: (context, index) {
                final city = savedCities[index];
                final weather = cityWeatherData[city];
                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: weather != null && weather['current'] != null && weather['current']['condition'] != null
                        ? const Icon(Icons.wb_sunny, size: 40.0, color: Colors.black)
                        : const Icon(Icons.error, size: 40.0, color: Colors.black),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(weather != null && weather['current'] != null && weather['current']['condition'] != null
                            ? weather['current']['condition']['text']
                            : 'N/A'),
                        Text(weather != null && weather['current'] != null && weather['current']['humidity'] != null
                            ? 'Humidity: ${weather['current']['humidity']}'
                            : 'N/A'),
                        Text(weather != null && weather['current'] != null && weather['current']['wind_kph'] != null
                            ? 'Wind: ${weather['current']['wind_kph']} km/h'
                            : 'N/A'),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          weather != null && weather['current'] != null && weather['current']['temp_c'] != null
                              ? '${weather['current']['temp_c']}°'
                              : 'N/A',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _openAddCityScreen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 39, 116, 107),
                ),
                child: const Text(
                  'Add More',
                  style: TextStyle(fontSize: 18,
                  color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
