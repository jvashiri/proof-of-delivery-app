import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(File image, String userId) async {
    try {
      // Get file extension
      String fileExtension = image.path.split('.').last;
      String fileName =
          "${DateTime.now().millisecondsSinceEpoch}.$fileExtension";
           print("User ID: $userId");
           print("File Name: $fileName");
      // Create a storage reference (organized per user)
      Reference ref = _storage.ref().child('users/$userId/images/$fileName');

      // Upload file
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      print("Upload successful,");
      // Get download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Failed to upload image: $e");
      return null;
    }
  }
}
