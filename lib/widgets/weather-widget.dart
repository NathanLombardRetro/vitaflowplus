import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String apiKey = '298d11a12b9047fe8cf121426241603 ';
  String city = 'Pretoria';
  String temperature = '';
  String condition = '';
  String weatherIcon = '';
  String advice = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    final response = await http.get(Uri.parse(
        'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        temperature = '${data['current']['temp_c']}°C';
        condition = data['current']['condition']['text'];
        weatherIcon = data['current']['condition']['icon'];
        isLoading = false;
        setAdvice(condition);
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  void setAdvice(String condition) {
    // Provide advice based on the weather condition
    if (condition == 'Sunny') {
      advice = 'It\'s a good day to go for a run!';
    } else {
      advice = 'Consider indoor activities today.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF26547C),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weather',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 253, 253, 252),
              ),
            ),
            SizedBox(height: 16.0),
            isLoading
                ? CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.network(
                            'https:$weatherIcon',
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '$condition',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 253, 253, 252),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Temperature: $temperature',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 253, 253, 252),
                        ),
                      ),
                      Text(
                        advice,
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Color.fromARGB(255, 253, 253, 252),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}