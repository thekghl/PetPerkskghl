import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import '../supabase_config.dart';

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Upload product image to Supabase storage
  Future<String> uploadProductImage(File imageFile) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'products/$fileName';

      await _supabase.storage
          .from(SupabaseConfig.productImagesBucket)
          .upload(
            path,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final imageUrl = _supabase.storage
          .from(SupabaseConfig.productImagesBucket)
          .getPublicUrl(path);
      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload product image: $e');
    }
  }

  /// Get public URL for a file in product bucket
  String getProductImageUrl(String filePath) {
    try {
      return _supabase.storage
          .from(SupabaseConfig.productImagesBucket)
          .getPublicUrl(filePath);
    } catch (e) {
      throw Exception('Failed to get product image URL: $e');
    }
  }

  /// Delete a file from product bucket
  Future<void> deleteProductImage(String filePath) async {
    try {
      await _supabase.storage
          .from(SupabaseConfig.productImagesBucket)
          .remove([filePath]);
    } catch (e) {
      throw Exception('Failed to delete product image: $e');
    }
  }

  /// List files in product bucket
  Future<List<FileObject>> listProductImages() async {
    try {
      final files = await _supabase.storage
          .from(SupabaseConfig.productImagesBucket)
          .list();
      return files;
    } catch (e) {
      throw Exception('Failed to list product images: $e');
    }
  }
}
