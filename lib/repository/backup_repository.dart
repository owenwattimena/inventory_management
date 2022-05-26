import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../services/database_service.dart';

class BackupRepository{
  static backup({bool isEncript = true, String? fileName}) async {
    DatabaseService database = DatabaseService();
    String backup = await database.generateBackup(isEncrypted: isEncript);
    var dir = (await getTemporaryDirectory()).absolute.path;
    final String path = "$dir/$fileName.inventory";
    final file = File(path);
    await file.writeAsString(backup);
    return path;
  }
}