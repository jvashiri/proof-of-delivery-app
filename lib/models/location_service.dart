import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationService {
  Future<String> getWhat3WordsAddress() async {
    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);
    double latitude = position.latitude;
    double longitude = position.longitude;

    final String url =
        'https://api.what3words.com/v3/convert-to-3wa?coordinates=$latitude,$longitude&key=01ZSS898';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['words'];
      } else {
        // Return the specific What3Words address in case of an error
        return 'already.tigers.recently';
      }
    } catch (e) {
      // Return the specific What3Words address in case of an error
      return 'already.tigers.recently';
    }
  }
}
