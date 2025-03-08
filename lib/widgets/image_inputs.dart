import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickedImage});
  final void Function(File image) onPickedImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
        preferredCameraDevice: CameraDevice.rear);
    if (pickedImage == null) {
      return;
    } else {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
      widget.onPickedImage(_selectedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ElevatedButton.icon(
      onPressed: _takePicture,
      icon: Icon(Icons.camera),
      label: Text("Take a picture"),
    );
    if (_selectedImage != null) {
      content = GestureDetector(
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          onTap: _takePicture);
    }

    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Theme.of(context).primaryColor.withOpacity(0.2),),),
      alignment: Alignment.center,
      //padding: EdgeInsets.all(100),
      child: content,
    );
  }
}
