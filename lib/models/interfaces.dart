import 'dart:io';

abstract class ILocationService {
  Future<String> getWhat3WordsAddress();
}

abstract class IImageService {
  Future<String> uploadImage(File image);
}

abstract class IDataService {
  Future<void> submitData(
    String deliveryType,
    String waybillNumber,
    String customerName,
    String consigneeName,
    String location,
    String phoneNumber,
    String driverEmail,
    String imageUrl,
  );
}
