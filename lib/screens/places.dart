import 'package:favourite_places/providers/user_places.dart';
import 'package:flutter/material.dart';

import 'package:favourite_places/screens/add_place.dart';
import 'package:favourite_places/widgets/places_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});
  @override
  ConsumerState<PlacesScreen> createState() {
    // TODO: implement createState
return _PlacesScreenState();
  }
}
class _PlacesScreenState extends ConsumerState<PlacesScreen>{
late Future <void> _placesFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _placesFuture= ref.read(userPlacesProvider.notifier).loadPlaces();
  }
  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("your places"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => AddPlaceScreen(),
                  ),
                );
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: FutureBuilder(builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting? Center(child: CircularProgressIndicator(),) :PlacesList(places: userPlaces), future: _placesFuture,) 
      ),
    );
  }
}
