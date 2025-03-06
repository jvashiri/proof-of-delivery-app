import 'package:flutter/material.dart';
import 'dart:io';
import 'package:driver_app/app_styles.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PocPodForm extends StatelessWidget {
  final String deliveryType;
  final TextEditingController waybillController;
  final TextEditingController customerController;
  final TextEditingController consigneeController;
  final TextEditingController phoneNumberController;
  final String location;
  final File? image;
  final String? imageUrl;
  final ValueChanged<String?> onDeliveryTypeChanged;
  final VoidCallback onCaptureLocation;
  final VoidCallback onShowImageSourceActionSheet;
  final VoidCallback onSubmitData;
  final bool isOnline;

  PocPodForm({
    required this.deliveryType,
    required this.waybillController,
    required this.customerController,
    required this.consigneeController,
    required this.phoneNumberController,
    required this.location,
    required this.image,
    required this.imageUrl,
    required this.onDeliveryTypeChanged,
    required this.onCaptureLocation,
    required this.onShowImageSourceActionSheet,
    required this.onSubmitData,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Delivery Type", style: labelStyle),
        SizedBox(height: 5),
        Container(
          decoration: inputDecoration,
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<String>(
            value: deliveryType,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down, color: Colors.black54),
            underline: SizedBox(),
            items: ["Collection", "Delivery"]
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: inputStyle),
                    ))
                .toList(),
            onChanged: onDeliveryTypeChanged,
          ),
        ),
        SizedBox(height: 15),
        buildTextField("Waybill Number", waybillController),
        buildTextField("Customer Name", customerController),
        buildTextField("Consignee/Name", consigneeController),
        buildTextField("Phone Number", phoneNumberController),
        SizedBox(height: 15),
        Text("Location", style: labelStyle),
        Container(
          decoration: inputDecoration,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: Text(
            location.isNotEmpty
                ? location
                : "Press the button to get location",
            style: inputStyle,
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: ElevatedButton.icon(
            onPressed: onCaptureLocation,
            icon: Icon(Icons.location_on),
            label: Text("Get Location"),
            style: buttonStyle,
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: ElevatedButton.icon(
            onPressed: onShowImageSourceActionSheet,
            icon: Icon(Icons.camera_alt),
            label: Text("Upload or Capture Image"),
            style: buttonStyle,
          ),
        ),
        SizedBox(height: 20),
        if (image != null || imageUrl != null)
          Center(
            child: kIsWeb
                ? Image.network(imageUrl!, height: 150)
                : Image.file(image!, height: 150),
          ),
        SizedBox(height: 20),
        Center(
          child: ElevatedButton.icon(
            onPressed: onSubmitData,
            icon: Icon(Icons.check_circle),
            label: Text("Submit POC/POD"),
            style: buttonStyle,
          ),
        ),
        if (!isOnline)
          Center(
            child: Text(
              "You are offline. Data will be saved locally and synced when online.",
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        SizedBox(height: 5),
        Container(
          decoration: inputDecoration,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(border: InputBorder.none),
            style: inputStyle,
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
