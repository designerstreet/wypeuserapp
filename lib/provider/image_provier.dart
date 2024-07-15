import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class SetImageProvider with ChangeNotifier {
  File? _selectedImage;

  File? get selectedImage => _selectedImage;

  Future<void> uploadImage({required ImageSource source}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners(); // Notify listeners of the change
    }
  }
}
