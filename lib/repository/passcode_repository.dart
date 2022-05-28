import 'package:shared_preferences/shared_preferences.dart';

class PasscodeRepository {

  static Future<String?> passcode ()async{
    final prefs = await SharedPreferences.getInstance();
    String? passcode =  prefs.getString('passcode');
    return passcode;
  }

  static Future<bool> setPasscode(String passcode) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('passcode', passcode);

    if(await PasscodeRepository.passcode() != null){
      return true;
    }
    return false;
  }

  static Future<bool> deletePasscode() async{
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove('passcode');
  }
}