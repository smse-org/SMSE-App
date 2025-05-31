import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarService {
  static const String _avatarPathKey = 'avatar_path';
  static const String _avatarTypeKey = 'avatar_type';

  Future<String?> getAvatarPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_avatarPathKey);
  }

  Future<void> saveAvatarPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarPathKey, path);
  }

  Future<String> getLocalPath() async {
    if (kIsWeb) {
      // For web, we'll use a temporary URL
      return 'temp';
    }
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> saveAvatarToLocal(io.File file) async {
    if (kIsWeb) {
      // For web, we'll return the file path directly
      return file.path;
    }
    
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}${_getFileExtension(file.path)}';
    final savedFile = await file.copy('${directory.path}/$fileName');
    await saveAvatarPath(savedFile.path);
    return savedFile.path;
  }

  String _getFileExtension(String path) {
    final extension = path.split('.').last.toLowerCase();
    return '.$extension';
  }
} 