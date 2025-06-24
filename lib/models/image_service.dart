import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker_platform_interface/src/types/image_source.dart';

class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(File image, String userId) async {
    try {
      // Get file extension
      String fileExtension = image.path.split('.').last;
      String fileName =
          "${DateTime.now().millisecondsSinceEpoch}.$fileExtension";
      // Create a storage reference (organized per user)
      Reference ref = _storage.ref().child('users/$userId/images/$fileName');

      // Upload file
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      // Get download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  pickImage(ImageSource source) {}

  saveImageLocally(File file) {}
}
