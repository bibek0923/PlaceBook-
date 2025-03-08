import 'package:favourite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key,
      this.location = const PlaceLocation(
          address: '', latitude: 37.422, longitude: -122.084),
      this.isSelecting = true});
  final PlaceLocation location;
  final isSelecting;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedlocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? "Pick your location" : "your location"),
        actions: [
          if (widget.isSelecting)
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop(_pickedlocation);
                },
                icon: Icon(Icons.save))
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting  ? null : (position) {
          setState(() {
            _pickedlocation = position;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 16,
        ),
        markers: (_pickedlocation == null && widget.isSelecting == true)
            ? {}
            : {
                Marker(
                    markerId: MarkerId('m1'),
                    position: _pickedlocation != null
                        ? _pickedlocation!
                        : LatLng(widget.location.latitude,
                            widget.location.longitude)),
              },
      ),
    );
  }
}
