// lib/utils/image_helper.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageHelper {
  static Widget buildImageWidget({
    required String? imagePath,
    double width = 100,
    double height = 100,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(10)),
  }) {
    if (imagePath == null) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: borderRadius,
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: const Icon(Icons.image_not_supported, size: 40),
      );
    }

    if (kIsWeb) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.network(
          imagePath,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: width,
            height: height,
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image, size: 40),
          ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.file(
          File(imagePath),
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      );
    }
  }
}
