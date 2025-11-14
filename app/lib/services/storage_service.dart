import 'dart:io';

class StorageService {
  // Upload a file (e.g., analyzed image) and return its URL
  Future<String> uploadFile(String path, String userId) async => '';

  // Download a file from storage
  Future<File> downloadFile(String url) async => File('');

  // Delete a file from storage
  Future<void> deleteFile(String url) async {}
}
