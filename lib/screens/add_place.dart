import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/providers/user_places.dart';
import 'package:favourite_places/widgets/image_inputs.dart';
import 'package:favourite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;
  void _savePlace() {
    final enteredTitle = _titleController.text;
    if (enteredTitle.isEmpty || _selectedImage == null||_selectedLocation==null) {
      return;
    }
    ref
        .read(userPlacesProvider.notifier)
        .addPlace(enteredTitle, _selectedImage!,_selectedLocation!);
    Navigator.of(context).pop();
  }

  void _getImage(File image) {
    _selectedImage = image;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add new places"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              controller: _titleController,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 20),
            ),
            SizedBox(
              height: 16,
            ),
            //image input
            ImageInput(
              // onPickedImage: (image) {
              //   _selectedImage = image;
              // },
              onPickedImage: _getImage,
            ),
            const SizedBox(
              height: 10,
            ),
            LocationInput(OnSelectLocation: (PlaceLocation location) {
              _selectedLocation = location;
            }),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
                icon: Icon(Icons.add),
                onPressed: _savePlace,
                label: Text("add place"))
          ],
        ),
      ),
    );
  }
}
