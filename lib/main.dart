import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Masukkan kota:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            CityInputForm(),
          ],
        ),
      ),
    );
  }
}

class CityInputForm extends StatefulWidget {
  @override
  _CityInputFormState createState() => _CityInputFormState();
}

class _CityInputFormState extends State<CityInputForm> {
  TextEditingController _cityController = TextEditingController();

  @override
  Future<void> sendData(String data) async {
    try {
      var dataSend = {'city': data};
      Dio dio = Dio();
      Response response = await dio.post(
        'http://10.0.2.2:3111/getCuaca',
        data: dataSend,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;

        Weather weather = Weather(
          coord: Coord(
            lon: responseData['coord']['lon'],
            lat: responseData['coord']['lat'],
          ),
          weather: [
            WeatherData(
              id: responseData['weather'][0]['id'],
              main: responseData['weather'][0]['main'],
              description: responseData['weather'][0]['description'],
              icon: responseData['weather'][0]['icon'],
            ),
          ],
          name: responseData['name'],
          main: MainData(
            temp: responseData['main']['temp'],
            feelsLike: responseData['main']['feels_like'],
            tempMin: responseData['main']['temp_min'],
            tempMax: responseData['main']['temp_max'],
            pressure: responseData['main']['pressure'],
            humidity: responseData['main']['humidity'],
            seaLevel: responseData['main']['sea_level'],
            groundLevel: responseData['main']['grnd_level'],
          ),
          visibility: responseData['visibility'],
          wind: Wind(
            speed: responseData['wind']['speed'],
            deg: responseData['wind']['deg'],
            gust: responseData['wind']['gust'],
          ),
          city: responseData['city'],
        );
        // tampilkan WeatherPage dan data dari respon
        print(response.data);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeatherPage(weather: weather),
          ),
        );
      } else {
        // Permintaan gagal
        print('Gagal mengirim data.');
      }
    } catch (error) {
      // Terjadi kesalahan dalam melakukan permintaan
      print('Kesalahan: $error');
    }
  }

  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          TextFormField(
            controller: _cityController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Kota',
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              String data = _cityController.text;
              sendData(data);
            },
            child: Text('Send Data'),
          ),
        ],
      ),
    );
  }
}

class WeatherPage extends StatelessWidget {
  final Weather weather;
  WeatherPage({required this.weather});

  @override
  Widget build(BuildContext context) {
    Future<void> sendData(String data) async {
      try {
        var dataSend = {'city': data};
        Dio dio = Dio();
        Response response = await dio.post(
          'http://10.0.2.2:3111/getCuaca',
          data: dataSend,
          options: Options(headers: {'Content-Type': 'application/json'}),
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;

          Weather weather = Weather(
            coord: Coord(
              lon: responseData['coord']['lon'],
              lat: responseData['coord']['lat'],
            ),
            weather: [
              WeatherData(
                id: responseData['weather'][0]['id'],
                main: responseData['weather'][0]['main'],
                description: responseData['weather'][0]['description'],
                icon: responseData['weather'][0]['icon'],
              ),
            ],
            name: responseData['name'],
            main: MainData(
              temp: responseData['main']['temp'],
              feelsLike: responseData['main']['feels_like'],
              tempMin: responseData['main']['temp_min'],
              tempMax: responseData['main']['temp_max'],
              pressure: responseData['main']['pressure'],
              humidity: responseData['main']['humidity'],
              seaLevel: responseData['main']['sea_level'],
              groundLevel: responseData['main']['grnd_level'],
            ),
            visibility: responseData['visibility'],
            wind: Wind(
              speed: responseData['wind']['speed'],
              deg: responseData['wind']['deg'],
              gust: responseData['wind']['gust'],
            ),
            city: responseData['city'],
          );
        } else {
          // Permintaan gagal
          print('Gagal mengirim data.');
        }
      } catch (error) {
        // Terjadi kesalahan dalam melakukan permintaan
        print('Kesalahan: $error');
      }
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Weather Details'),
      ),
      body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              // get city.name
              Text(weather.name,
                  style: new TextStyle(color: Colors.white, fontSize: 32.0)),
              if (weather.weather[0].main == 'Rain') ...[
                Text('Hujan',
                    style: new TextStyle(color: Colors.white, fontSize: 24.0)),
                Image.network('https://openweathermap.org/img/w/10d.png')
              ] else if (weather.weather[0].main == 'Clouds') ...[
                Text('Berawan',
                    style: new TextStyle(color: Colors.white, fontSize: 24.0)),
                Image.network('https://openweathermap.org/img/w/03d.png')
              ] else if (weather.weather[0].main == 'Clear') ...[
                Text('Cerah',
                    style: new TextStyle(color: Colors.white, fontSize: 24.0)),
                Image.network('https://openweathermap.org/img/w/01d.png'),
              ],
              Text((weather.main.temp! / 10).toInt().toString() + '°C\n',
                  style: new TextStyle(color: Colors.white)),
              Text(
                  DateTime.now().day.toString() +
                      '/' +
                      DateTime.now().month.toString() +
                      '/' +
                      DateTime.now().year.toString() +
                      '\n',
                  style: new TextStyle(color: Colors.white)),

              Text(
                  DateTime.now().hour.toString() +
                      ':' +
                      DateTime.now().minute.toString() +
                      ' WIB',
                  style: new TextStyle(color: Colors.white)),
            ],
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: IconButton(
        //     icon: new Icon(Icons.refresh),
        //     tooltip: 'Refresh',
        //     onPressed: () => {sendData(weather.city)},
        //     color: Colors.white,
        //   ),
        // )
      ])),
    );
  }
}

class Weather {
  final Coord coord;
  final List<WeatherData> weather;
  final String name;
  final MainData main;
  final int visibility;
  final Wind wind;
  final String city;

  Weather({
    required this.coord,
    required this.weather,
    required this.name,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.city,
  });
}

class Coord {
  final double lon;
  final double lat;

  Coord({
    required this.lon,
    required this.lat,
  });
}

class WeatherData {
  final int id;
  final String main;
  final String description;
  final String icon;

  WeatherData({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });
}

class MainData {
  final double? temp;
  final double? feelsLike;
  final double? tempMin;
  final double? tempMax;
  final int? pressure;
  final int? humidity;
  final int? seaLevel;
  final int? groundLevel;

  MainData({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.seaLevel,
    required this.groundLevel,
  });
}

class Wind {
  final double? speed;
  final int? deg;
  final double? gust;

  Wind({
    required this.speed,
    required this.deg,
    required this.gust,
  });
}
