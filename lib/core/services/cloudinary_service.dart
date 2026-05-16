import 'dart:developer';

import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  final cloudinary = CloudinaryPublic(
    'dgszo0lwo',
    'radiology_results',
    cache: false,
  );

  Future<String> uploadFile(String filePath) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(filePath),
      );

      return response.secureUrl;
    } catch (e) {
      log('Cloudinary upload error: $e');

      throw Exception('Cloudinary upload failed');
    }
  }
}
