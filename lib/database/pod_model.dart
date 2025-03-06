class PodModel {
  final String waybillNumber;
  final String deliveryType;
  final String customerName;
  final String consigneeName;
  final String location;
  final String? imagePath;  // Optional field for image path, if any

  // Constructor
  PodModel({
    required this.waybillNumber,
    required this.deliveryType,
    required this.customerName,
    required this.consigneeName,
    required this.location,
    this.imagePath,
  });

  // Convert a PodModel object into a Map object (used for Firestore and SQLite)
  Map<String, dynamic> toMap() {
    return {
      'waybillNumber': waybillNumber,
      'deliveryType': deliveryType,
      'customerName': customerName,
      'consigneeName': consigneeName,
      'location': location,
      'imagePath': imagePath,  // Optional, can be null
    };
  }

  // Create a PodModel from a Map object (used for converting data fetched from Firestore and SQLite)
  factory PodModel.fromMap(Map<String, dynamic> map) {
    return PodModel(
      waybillNumber: map['waybillNumber'] ?? '',
      deliveryType: map['deliveryType'] ?? '',
      customerName: map['customerName'] ?? '',
      consigneeName: map['consigneeName'] ?? '',
      location: map['location'] ?? '',
      imagePath: map['imagePath'],  // Can be null
    );
  }

  // Function to display the object as a string
  @override
  String toString() {
    return 'PodModel{waybillNumber: $waybillNumber, deliveryType: $deliveryType, customerName: $customerName, consigneeName: $consigneeName, location: $location, imagePath: $imagePath}';
  }
}
