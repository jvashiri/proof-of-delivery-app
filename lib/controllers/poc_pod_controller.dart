import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/poc_pod_view_model.dart';

class PocPodController {
  final PocPodViewModel viewModel;
  final BuildContext context;

  PocPodController({required this.viewModel, required this.context});

  void showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Choose from Gallery'),
              onTap: () {
                viewModel.pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                viewModel.pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red.shade400),
    );
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return 'Phone Number is required';
    final pattern = RegExp(r'^\+27\d{9}$');
    if (!pattern.hasMatch(value)) return 'Enter valid number (+27XXXXXXXXX)';
    return null;
  }

  Future<void> saveForm(GlobalKey<FormState> formKey) async {
    final phone = viewModel.phoneNumberController.text.trim();
    if (!phone.startsWith('+27')) {
      viewModel.phoneNumberController.text = '+27$phone';
    }

    if (formKey.currentState!.validate()) {
      try {
        if (kIsWeb) {
          // Save online when running on web
          await viewModel.saveDataToWebDatabase();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data saved online')),
          );
        } else {
          // Save locally when on mobile
          await viewModel.saveDataLocally();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data saved locally')),
          );
        }

        viewModel.clearForm();
      } catch (e) {
        showError('Failed to save data: ${e.toString()}');
      }
    } else {
      showError('Please complete the form');
    }
  }
}
