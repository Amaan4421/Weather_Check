import 'package:flutter/material.dart';
import 'package:weather_check/Services/weather_data_fetch.dart';
import 'package:weather_check/UI/home_screen.dart';

class SearchResultScreen extends StatefulWidget {

  final String city;

  const SearchResultScreen({super.key, required this.city});

  @override
  // ignore: library_private_types_in_public_api
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {

  // ignore: prefer_typing_uninitialized_variables
  var weatherData, sunData, hourlyData, weeklyData;
  String? errorMessage;
  bool showHourlyForecast = true;

  @override
  void initState() {
    super.initState();
    fetchWeather(widget.city);
  }

  fetchWeather(String city) async {
    try 
    {
      var data = await WeatherService().getWeather(city);
      var sunTimeData = await WeatherService().getTimeData(city);
      var hourlyForecast = await WeatherService().getHourlyData(city);
      var weeklyForecast = await WeatherService().getWeeklyData(city);
      
      setState(() {
        weatherData = data;
        sunData = sunTimeData;
        hourlyData = hourlyForecast;
        weeklyData = weeklyForecast;
        errorMessage = null;
      });
    } 
    catch (e) 
    {
      setState(() 
      {
        errorMessage = e.toString();
        weatherData = null;
        sunData = null;
        hourlyData = null;
        weeklyData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
          },
        ),
        title: Text(
          'Weather for ${widget.city}',
          style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        backgroundColor: const Color.fromARGB(255, 153, 250, 233),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/home_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.fromLTRB(130, 110, 0, 0)),
                  if (weatherData != null && sunData != null) ...[
                    Text(
                      weatherData['location'] != null && weatherData['location']['name'] != null
                          ? weatherData['location']['name']
                          : 'N/A',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      weatherData['current'] != null && weatherData['current']['temp_c'] != null
                          ? '${weatherData['current']['temp_c']}°'
                          : 'N/A',
                      style:  const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      weatherData['current'] != null && weatherData['current']['condition'] != null && weatherData['current']['condition']['text'] != null
                          ? weatherData['current']['condition']['text']
                          : 'N/A',
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 39, 116, 107).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              weatherInfoCard(
                                icon: Icons.water_drop,
                                label: 'HUMIDITY',
                                value: weatherData['current'] != null && weatherData['current']['humidity'] != null
                                    ? '${weatherData['current']['humidity']}%'
                                    : 'N/A',
                              ),
                              weatherInfoCard(
                                icon: Icons.air,
                                label: 'WIND',
                                value: weatherData['current'] != null && weatherData['current']['wind_kph'] != null
                                    ? '${weatherData['current']['wind_kph']} km/h'
                                    : 'N/A',
                              ),
                              weatherInfoCard(
                                icon: Icons.thermostat,
                                label: 'FEELS LIKE',
                                value: weatherData['current'] != null && weatherData['current']['feelslike_c'] != null
                                    ? '${weatherData['current']['feelslike_c']}°'
                                    : 'N/A',
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              weatherInfoCard(
                                icon: Icons.sunny,
                                label: 'SUNRISE',
                                value: sunData['astronomy'] != null && sunData['astronomy']['astro'] != null && sunData['astronomy']['astro']['sunrise'] != null
                                    ? '${sunData['astronomy']['astro']['sunrise']}'
                                    : 'N/A',
                              ),
                              weatherInfoCard(
                                icon: Icons.sunny,
                                label: 'SUNSET',
                                value: sunData['astronomy'] != null && sunData['astronomy']['astro'] != null && sunData['astronomy']['astro']['sunset'] != null
                                    ? '${sunData['astronomy']['astro']['sunset']}'
                                    : 'N/A',
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    showHourlyForecast = true;
                                  });
                                },
                                child: Text(
                                  'Hourly Forecast',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: showHourlyForecast ? Colors.black : Colors.grey,
                                    shadows: showHourlyForecast
                                        ? [const Shadow(offset: Offset(2.0, 2.0), blurRadius: 3.0, color: Colors.grey)]
                                        : [],
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    showHourlyForecast = false;
                                  });
                                },
                                child: Text(
                                  'Weekly Forecast',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: showHourlyForecast ? Colors.grey : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 300,
                            child: showHourlyForecast
                                ? hourlyData != null
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: hourlyData['forecast']['forecastday'][0]['hour'].length,
                                        itemBuilder: (context, index) {
                                          var hour = hourlyData['forecast']['forecastday'][0]['hour'][index];
                                          return Container(
                                            width: 130,
                                            margin: const EdgeInsets.symmetric(horizontal: 5),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(80, 49, 157, 144),
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  hour['time'],
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 10),
                                                Image.network('http:${hour['condition']['icon']}'),
                                                const SizedBox(height: 10),
                                                Text(
                                                  '${hour['temp_c']}°',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    : const Center(child: CircularProgressIndicator())
                                : weeklyData != null
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: weeklyData['forecast']['forecastday'].length,
                                        itemBuilder: (context, index) {
                                          var day = weeklyData['forecast']['forecastday'][index];
                                          return Container(
                                            width: 130,
                                            margin: const EdgeInsets.symmetric(horizontal: 5),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(80, 49, 157, 144),
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  day['date'],
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 10),
                                                Image.network('http:${day['day']['condition']['icon']}'),
                                                const SizedBox(height: 10),
                                                Text(
                                                  '${day['day']['avgtemp_c']}°',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    : const Center(child: CircularProgressIndicator()),
                          )
                        ],
                      ),
                    ),
                  ] else if (errorMessage != null) ...[
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ] else ...[
                    const Center(child: CircularProgressIndicator()),
                  ],
                ],
              ),
            ),
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     decoration: const BoxDecoration(
          //       color: Color.fromARGB(130, 153, 250, 233),
          //       borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(20),
          //         topRight: Radius.circular(20),
          //       ),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black26,
          //           blurRadius: 10,
          //           offset: Offset(0, -2),
          //         ),
          //       ],
          //     ),
          //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         IconButton(
          //           icon: Image.asset(
          //               'assets/bookmark.png',
          //               width: 35,
          //               height: 35,
          //               color: Colors.black,
          //           ),
          //           onPressed: () {},
          //         ),
          //         Container(
          //           decoration: const BoxDecoration(
          //             shape: BoxShape.circle,
          //             color: Color.fromARGB(148, 83, 172, 156),
          //           ),
          //           child: IconButton(
          //             icon: Image.asset(
          //               'assets/search.png',
          //               width: 40,
          //               height: 40,
          //             ),
          //             onPressed: () {
          //               Navigator.push(
          //                 context,
          //                 MaterialPageRoute(builder: (context) => const SearchScreen())
          //               );
          //             },
          //           ),
          //         ),
          //         IconButton(
          //           icon: Image.asset(
          //               'assets/home.png',
          //               width: 35,
          //               height: 35,
          //               color: Colors.black,
          //           ),
          //           onPressed: () {
          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(builder: (context) => const HomeScreen())
          //               );
          //           },
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget weatherInfoCard({required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon, color: Colors.black),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }
}
