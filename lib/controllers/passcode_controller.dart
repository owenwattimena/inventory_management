import 'package:inventory_management/repository/passcode_repository.dart';
import 'package:get/get.dart';

class PasscodeController extends GetxController {
  Rx<String> passcode = ''.obs;

  Future<bool> setPasscode(String passcode) async =>
    await PasscodeRepository.setPasscode(passcode);

  Future<bool> deletePasscode() async => await PasscodeRepository.deletePasscode();
}
