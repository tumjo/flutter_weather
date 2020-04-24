import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http; // require http.* before use
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyWeather());
  }
}

class MyWeather extends StatefulWidget {
  @override
  _MyWeatherState createState() => _MyWeatherState();
}

class _MyWeatherState extends State<MyWeather> {
  // ** muuttujat **
  var latitude = '-';
  var longitude = '-';
  String cityname = '-';
  String temperature = '-';
  String humidity = '-';
  String windspeed = '-';
  String weatherdescription = '-';

  // ** metodit **
  // async tyyppinen koordinaattien haku, koska käytetään await. await, koska odotetaan futuuria. Metodi palauttaa tuoloksen vasta kun valmis.
  void getMyLocation() async {
    // Käytetään pakettia geolocator
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // Asetetaan teksti
      setState(() {
        latitude = position.latitude.toStringAsFixed(1);
        longitude = position.longitude.toStringAsFixed(1);
      });
      print(position); //test
      getMyWeather(latitude, longitude);
    } catch (e) {
      // if location permission denied or location data is not available on device
      print(e);
    }
  }

  void getMyWeather(var lat, var long) async {
    String url = 'https://api.openweathermap.org/data/2.5/weather?lat=' +
        lat +
        '&lon=' +
        long +
        '&units=metric&appid=053b6edc425a34d52c32d012a86eec21&lang=fi';
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body); //test
      var jsonDecoded = jsonDecode(response.body);
      setState(() {
        cityname = jsonDecoded['name'];
        temperature = jsonDecoded['main']['temp'].toString();
        weatherdescription = jsonDecoded['weather'][0]['description'];
        humidity = jsonDecoded['main']['humidity'].toString();
        windspeed = jsonDecoded['wind']['speed'].toString();
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter: Weather'),
        backgroundColor: Colors.deepOrange[500],
      ),
      backgroundColor: Colors.deepOrange[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(12.0),
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: <Widget>[
                  Text('Paikkakunta: $cityname',
                      style: TextStyle(
                          fontSize: 20.0, color: Colors.deepOrange[500]))
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(12.0),
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: <Widget>[
                  Text('Lämpötila: $temperature C',
                      style: TextStyle(
                          fontSize: 16.0, color: Colors.deepOrange[500]))
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(12.0),
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: <Widget>[
                  Text('Sää nyt: $weatherdescription',
                      style: TextStyle(
                          fontSize: 16.0, color: Colors.deepOrange[500]))
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(12.0),
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: <Widget>[
                  Text('Ilmankosteus: $humidity %',
                      style: TextStyle(
                          fontSize: 16.0, color: Colors.deepOrange[500]))
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(12.0),
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: <Widget>[
                  Text('Tuulen nopeus: $windspeed m/s',
                      style: TextStyle(
                          fontSize: 16.0, color: Colors.deepOrange[500]))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    print('Pressed!!');
                    getMyLocation();
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.deepOrange,
                          Colors.deepOrangeAccent,
                          Colors.orange,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text('Hae sijainnin sää',
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Long: $longitude\nLat: $latitude',
                    style: TextStyle(fontSize: 8), //test
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
