import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:driver_app/models/location_service.dart';
import 'package:driver_app/models/image_service.dart';
import 'package:driver_app/models/data_service.dart';
import 'package:driver_app/models/authentication_service.dart';
import 'package:driver_app/models/connectivity_service.dart';
import 'package:driver_app/models/local_storage_service.dart';
import 'package:driver_app/models/poc_pod_view_model.dart';
import 'package:driver_app/widgets/poc_pod_form.dart'; // Import the form widget

class PocPodScreen extends StatelessWidget {
  final bool isOnline;

  PocPodScreen({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PocPodViewModel(
        locationService: LocationService(),
        imageService: ImageService(),
        dataService: DataService(),
        authService: AuthenticationService(),
        connectivityService: ConnectivityService(),
        localStorageService: LocalStorageService(),
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Consumer<PocPodViewModel>(
            builder: (context, viewModel, child) {
              return PocPodForm(
                deliveryType: viewModel.deliveryType,
                waybillController: viewModel.waybillController,
                customerController: viewModel.customerController,
                consigneeController: viewModel.consigneeController,
                phoneNumberController: viewModel.phoneNumberController,
                location: viewModel.location,
                image: viewModel.image,
                imageUrl: viewModel.imageUrl,
                onDeliveryTypeChanged: (val) =>
                    viewModel.deliveryType = val as String,
                onCaptureLocation: viewModel.captureLocation,
                onShowImageSourceActionSheet: () =>
                    showImageSourceActionSheet(context, viewModel),
                onSubmitData: () async {
                  try {
                    await viewModel.submitData(isOnline);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("POC/POD Captured Successfully")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
                isOnline: isOnline,
              );
            },
          ),
        ),
      ),
    );
  }

  void showImageSourceActionSheet(BuildContext context, PocPodViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  viewModel.pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  viewModel.pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
