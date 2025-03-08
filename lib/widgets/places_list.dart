import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/providers/user_places.dart';
import 'package:favourite_places/screens/places_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesList extends ConsumerStatefulWidget {
  const PlacesList({dynamic key, required this.places});
  final List<Place> places;

  @override
  ConsumerState<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends ConsumerState<PlacesList> {
  @override
  Widget build(BuildContext context) {
    //final places = ref.read(userPlacesProvider.notifier);

    if (widget.places.isEmpty) {
      return Center(
        child: Text(
          "no places added",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      );
    }
    return ListView.builder(
      itemCount: widget.places.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(widget.places[index].title),
        onDismissed: (direction) async{
          final deletedPlace = widget.places[index];
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
             
              content: Text("place deleted"),
              action: SnackBarAction(
                label: "undo",
                onPressed: () {
                  ref.read(userPlacesProvider.notifier).insertPlace(
                      deletedPlace.title,
                      deletedPlace.image,
                      deletedPlace.location);
                },
              ),
            ),
          );
          
          ref
              .read(userPlacesProvider.notifier)
              .deletePlace(widget.places[index].id);
              
        },
        child: ListTile(
          leading: CircleAvatar(
              radius: 22,
              backgroundImage: FileImage(widget.places[index].image)),
          title: Text(
            widget.places[index].title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          subtitle: Text(
            widget.places[index].location.address,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return PlaceDetailsScreen(
                place: widget.places[index],
                image: widget.places[index].image,
              );
            }));
          },
        ),
      ),
    );
  }
}
