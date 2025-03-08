import 'dart:convert';
// import 'dart:ffi';

import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/screens/maps_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.OnSelectLocation});
  final void Function(PlaceLocation location) OnSelectLocation;

  @override
  State<LocationInput> createState() => __LocationInputStateState();
}

class __LocationInputStateState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }

    final lat = _pickedLocation!.latitude;
    final long = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$long&key=AIzaSyBrDALgmEhF5R1jNIkdG-wltCqU_tGyfvk';
  }

  Future<void> _savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyBrDALgmEhF5R1jNIkdG-wltCqU_tGyfvk");
    final response = await http.get(url);
    final resData = jsonDecode(response.body);
    // print(resData);
    final address = resData["results"][0]["formatted_address"];
    print(address);

    setState(() {
      _pickedLocation = PlaceLocation(
          address: address, latitude: latitude, longitude: longitude);
      _isGettingLocation = false;
    });
    // print(_locationData.latitude);
    // print(_locationData.longitude);
    widget.OnSelectLocation(_pickedLocation!);
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });
    _locationData = await location.getLocation();
    final lat = _locationData.latitude;
    final long = _locationData.longitude;
    if (lat == null || long == null) {
      return;
    }
    _savePlace(lat, long);
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(),
      ),
    );
    if (pickedLocation == null) {
      return;
    }
    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No location chosen",
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );
    if (_isGettingLocation) {
      previewContent = CircularProgressIndicator();
    }
    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: Icon(Icons.location_on),
              label: Text("Get current location"),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text("select on map"),
            ),
          ],
        )
      ],
    );
  }
}
