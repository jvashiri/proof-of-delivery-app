import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver_app/models/poc_pod_view_model.dart';
import '../controllers/poc_pod_controller.dart';
import '../utils/image_helper.dart';

class PocPodScreen extends StatefulWidget {
  final bool isOnline;
  const PocPodScreen({super.key, required this.isOnline});

  @override
  State<PocPodScreen> createState() => _PocPodScreenState();
}

class _PocPodScreenState extends State<PocPodScreen> {
  final _formKey = GlobalKey<FormState>();
  final Color primaryGreen = const Color(0xFF388E3C);
  late PocPodViewModel viewModel;
  late PocPodController controller;

  @override
  void initState() {
    super.initState();
    viewModel = PocPodViewModel();
  }

  @override
  Widget build(BuildContext context) {
    controller = PocPodController(viewModel: viewModel, context: context);

    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<PocPodViewModel>(
        builder: (context, model, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFF0F8F1),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildFormCard(model),
                    const SizedBox(height: 30),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormCard(PocPodViewModel model) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildDropdown(model),
            const SizedBox(height: 16),
            _buildTextField(model.waybillController, 'Waybill Number'),
            _buildTextField(model.customerController, 'Customer Name'),
            _buildTextField(
              model.consigneeController,
              model.deliveryType == 'Pickup' ? 'Shipper' : 'Consignee',
            ),
            _buildTextField(
              model.phoneNumberController,
              'Phone Number',
              keyboardType: TextInputType.phone,
              validator: controller.validatePhoneNumber,
              prefixText: '+27',
              prefixStyle: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            _buildImageUploadSection(model),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(PocPodViewModel model) {
    return DropdownButtonFormField<String>(
      value: model.deliveryType,
      decoration: InputDecoration(
        labelText: 'Delivery Type',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: const [
        DropdownMenuItem(value: 'Pickup', child: Text('Pickup')),
        DropdownMenuItem(value: 'Dropoff', child: Text('Dropoff')),
      ],
      onChanged: (val) {
        if (val != null) model.deliveryType = val;
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    String? prefixText,
    TextStyle? prefixStyle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixText: prefixText,
          prefixStyle: prefixStyle,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: validator ??
            (value) =>
                (value == null || value.isEmpty) ? '$label is required' : null,
      ),
    );
  }

  Widget _buildImageUploadSection(PocPodViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Proof of Delivery Image',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            ImageHelper.buildImageWidget(imagePath: model.image?.path),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Image'),
              onPressed: controller.showImageSourceOptions,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade50,
                foregroundColor: primaryGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildSaveButton() {
    return FilledButton.icon(
      icon: const Icon(Icons.save),
      label: const Text('Save Details'),
      style: FilledButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () => controller.saveForm(_formKey),
    );
  }
}
