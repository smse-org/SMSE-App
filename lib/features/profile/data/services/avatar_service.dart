import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarService {
  static const String _avatarPathKey = 'avatar_path';

  Future<String?> getAvatarPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_avatarPathKey);
  }

  Future<void> saveAvatarPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarPathKey, path);
  }

  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> saveAvatarToLocal(File imageFile) async {
    final localPath = await getLocalPath();
    final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedImage = await imageFile.copy('$localPath/$fileName');
    await saveAvatarPath(savedImage.path);
    return savedImage.path;
  }
} 