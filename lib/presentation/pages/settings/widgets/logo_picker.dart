import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LogoPicker extends StatelessWidget {
  final String? currentLogo;
  final Function(String) onLogoSelected;

  const LogoPicker({
    super.key,
    this.currentLogo,
    required this.onLogoSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(context),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: currentLogo != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(currentLogo!),
                  fit: BoxFit.cover,
                ),
              )
            : Icon(
                Icons.add_photo_alternate,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      onLogoSelected(pickedFile.path);
    }
  }
}
