import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management/repository/backup_repository.dart';
import 'package:share_plus/share_plus.dart';

class BackupController extends GetxController {
  Rx<PlatformFile> file = Rx<PlatformFile>(PlatformFile(name: '', size: 0));
  Future<bool> saveBackup() async {
    final id = DateFormat('yyyyMMddhhmmss').format(DateTime.now());
    await BackupRepository.saveBackup(fileName: id + '_backup');
    return true;
  }

  void shareBackup() async {
    final id = DateFormat('yyyyMMddhhmmss').format(DateTime.now());
    final _backup = await BackupRepository.backup(fileName: id + '_backup');
    Share.shareFiles([_backup]);
  }

  Future<bool> openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file.value = result.files.first;
      return true;
    }
    return false;
  }

  Future<bool> restoreBackup() async {
    final result = await BackupRepository.restoreBackup(file.value);
    return result;
  }
}
