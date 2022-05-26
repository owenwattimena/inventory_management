import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management/repository/backup_repository.dart';
import 'package:share_plus/share_plus.dart';

class BackupController extends GetxController
{
  void shareBackup() async {
    final id = DateFormat('yyyyMMddhhmmss').format(DateTime.now());
    final _backup = await BackupRepository.backup(fileName: id + '_backup');
    Share.shareFiles([
      _backup
    ]);
  }
}