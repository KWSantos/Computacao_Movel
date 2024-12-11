import 'package:http/http.dart' as http;
import 'dart:convert';

final String token = 'wif2pYPQ9DU8tdi0yDYqrWbToZw4msLnB5m5hETV';

Future<Map> astronomicPicturyOfTheDay(String? date) async {
    http.Response response;
    response = await http.get(Uri.parse('https://api.nasa.gov/planetary/apod?api_key=$token'));
    return json.decode(response.body);
}

Future<Map> earthImageOfTheDay(double? lat, double? lon, double? dim, String? date, bool? cloud_score) async {
    http.Response response;
    response = await http.get(Uri.parse('https://api.nasa.gov/planetary/earth/imagery?lon=$lon&lat=$lat&date=$date&api_key=$token'));
    return json.decode(response.body);
}