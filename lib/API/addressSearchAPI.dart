import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:santhe/SECRETKEY.dart';
import 'package:santhe/pages/ondc/map_address_ondc/map_address_ondc_view.dart';

import '../pages/customer_registration_pages/mapAddressPicker.dart';

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();
  final apiKey = Key.GOOGLEMAPKEY;

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=geocode&language=$lang&components=country:IN&key=$apiKey';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  void getPlaceDetailFromId(String placeId) async {
    final request =
        'https://maps.googleapis.com/maps/api/geocode/json?place_id=$placeId&key=$apiKey';
    final response = await client.get(Uri.parse(request));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        var lat = result['results'][0]['geometry']['location']['lat'];
        var lng = result['results'][0]['geometry']['location']['lng'];
        Get.to(() => MapAddressPicker(lat: lat, lng: lng));
      }
      //throw Exception(result['error_message']);
    } else {
      //throw Exception('Failed to fetch suggestion');
    }
  }

  void getPlaceDetailFromIdv2(String placeId, String? whichScreen) async {
    final request =
        'https://maps.googleapis.com/maps/api/geocode/json?place_id=$placeId&key=$apiKey';
    final response = await client.get(Uri.parse(request));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        var lat = result['results'][0]['geometry']['location']['lat'];
        var lng = result['results'][0]['geometry']['location']['lng'];
        Get.to(() => MapAddressOndcView(
              lat: lat,
              lng: lng,
              whichScreen: whichScreen,
            ));
      }
      //throw Exception(result['error_message']);
    } else {
      //throw Exception('Failed to fetch suggestion');
    }
  }

  Future<String> getAddressFromLatLong(String lat, String long) async {
    final request =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$apiKey';
    final response = await client.get(Uri.parse(request));
    var res = json.decode(response.body);
    return res['results'][0]["formatted_address"].toString();
  }
}
