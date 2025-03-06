import 'dart:io';
import 'package:driver_app/models/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver_app/models/location_service.dart';
import 'package:driver_app/models/image_service.dart';
import 'package:driver_app/models/data_service.dart';
import 'package:driver_app/models/connectivity_service.dart';
import 'package:driver_app/models/local_storage_service.dart';

class PocPodViewModel extends ChangeNotifier {
  String deliveryType = "Collection";

  // Controllers for form input
  final TextEditingController waybillController = TextEditingController();
  final TextEditingController customerController = TextEditingController();
  final TextEditingController consigneeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  File? image;
  //String? imageUrl;
  String location = "";
  String? driverEmail;

  final LocationService _locationService;
  final ImageService _imageService;
  final DataService _dataService;

  PocPodViewModel({
    required LocationService locationService,
    required ImageService imageService,
    required DataService dataService,
    required ConnectivityService connectivityService,
    required LocalStorageService localStorageService,
    required AuthenticationService authService,
  })  : _locationService = locationService,
        _imageService = imageService,
        _dataService = dataService {
    _fetchCurrentUserEmail();
  }

  get imageUrl => null;

  /// Fetches the currently logged-in user's email
  Future<void> _fetchCurrentUserEmail() async {
    try {
      driverEmail = FirebaseAuth.instance.currentUser?.email;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching user email: $e");
    }
  }

  /// Captures the user's current location
  Future<void> captureLocation() async {
    try {
      location = await _locationService.getWhat3WordsAddress();
      notifyListeners();
    } catch (e) {
      debugPrint("Error capturing location: $e");
    }
  }

  /// Picks an image from the specified source (Camera or Gallery)
  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        image = File(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  /// Submits data, ensuring an image is uploaded before proceeding
  Future<void> submitData(bool isOnline) async {
    if (image == null) {
      throw Exception("Please capture or upload an image");
    }
    if (driverEmail == null) {
      throw Exception("Driver email not available");
    }

    try {
      /*if (isOnline) {
        imageUrl = await _uploadImage(image!, driverEmail!);
        if (imageUrl == null) {
          throw Exception("Error uploading image");
        }
      }*/

      await _dataService.submitData(
        deliveryType,
        waybillController.text,
        customerController.text,
        consigneeController.text,
        location,
        phoneNumberController.text,
        driverEmail!,
        //
        isOnline,
      );

      _clearForm();
    } catch (e) {
      debugPrint("Error submitting data: $e");
      throw e;
    }
  }

  /// Uploads an image to Firebase Storage
  // ignore: unused_element
  Future<String?> _uploadImage(File image, String userId) async {
    try {
      return await _imageService.uploadImage(image, userId);
    } catch (e) {
      debugPrint("Failed to upload image: $e");
      throw Exception("Failed to upload image: $e");
    }
  }

  /// Clears form fields after submission
  void _clearForm() {
    waybillController.clear();
    customerController.clear();
    consigneeController.clear();
    phoneNumberController.clear();
    location = "";
    image = null;
    //imageUrl = null;
    notifyListeners();
  }
}
