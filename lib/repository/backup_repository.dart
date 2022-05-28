import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';

import '../services/database_service.dart';

class BackupRepository{
  static Future<String> backup({bool isEncript = true, String? fileName}) async {
    DatabaseService database = DatabaseService();
    String backup = await database.generateBackup(isEncrypted: isEncript);
    var dir = (await getTemporaryDirectory()).absolute.path;
    final String path = "$dir/$fileName.inventory";
    final file = File(path);
    await file.writeAsString(backup);
    return path;
  }

  static Future<String> saveBackup({bool isEncript = true, String? fileName}) async {
    String backup = await DatabaseService().generateBackup(isEncrypted: isEncript);
    var dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOCUMENTS);
    var _dir = await Directory("$dir/inventory_management").create();
    final String path = "${_dir.path}/$fileName.inventory";
    final file = File(path);
    await file.writeAsString(backup);
    return path;
  }

  static Future<bool> restoreBackup(PlatformFile file, {bool isEncrypted = true}) async {
    DatabaseService database = DatabaseService();
    final input = await File(file.path!).readAsString();
    bool result =  await database.restoreBackup(input, isEncrypted: isEncrypted);
    return result;
  }

}