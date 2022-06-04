import 'package:get/get.dart';
import 'package:inventory_management/models/transaction_list.dart';
import 'package:inventory_management/repository/passcode_repository.dart';

import '../models/transaction.dart';
import '../repository/transaction_repository.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;
  Rx<List<TransactionList?>> entryTransactionList =
      Rx<List<TransactionList>>([]);
  Rx<List<TransactionList?>> outTransactionList = Rx<List<TransactionList>>([]);
  Rx<List<TransactionList?>> auditTransactionList =
      Rx<List<TransactionList>>([]);
  Rx<DateTime> currentDate = DateTime.now().obs;
  Rx<bool> isPasscodeOn = false.obs;
  Rx<String?> passcode = Rx<String?>(null);
  RxBool isTabOutActive = true.obs;

  @override
  void onInit() {
    super.onInit();
    getPasscode();
  }

  Future<String?> getPasscode() async {
    final _passcode =  await PasscodeRepository.passcode();
    passcode.value = _passcode;
    return _passcode;
  }

  set setSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  int getDateStart() {
    return DateTime(currentDate.value.year, currentDate.value.month, 1)
        .millisecondsSinceEpoch;
  }

  int getDateEnd() {
    return DateTime(
            currentDate.value.year, currentDate.value.month + 1, 0, 23, 59, 59)
        .millisecondsSinceEpoch;
  }

  void prevNextYear({bool? next, bool? prev}) {
    DateTime now = currentDate.value;
    if (next != null && next) {
      currentDate.value = DateTime(now.year + 1, now.month, now.day);
    } else if (prev != null && prev) {
      currentDate.value = DateTime(now.year - 1, now.month, now.day);
    }
    getAllTransactionList(dateStart: getDateStart(), dateEnd: getDateEnd());
  }

  void goToMonth(int month, {int? year}) {
    DateTime now = currentDate.value;
    currentDate.value = DateTime(year ?? now.year, month, now.day);
    getAllTransactionList(dateStart: getDateStart(), dateEnd: getDateEnd());
  }

  void prevNextMonth({bool? next, bool? prev}) {
    DateTime now = currentDate.value;
    if (next != null && next) {
      currentDate.value = DateTime(now.year, now.month + 1, now.day);
    } else if (prev != null && prev) {
      currentDate.value = DateTime(now.year, now.month - 1, now.day);
    }
    getAllTransactionList(dateStart: getDateStart(), dateEnd: getDateEnd());
  }

  Future<bool> createTransaction(Transaction transaction) async {
    final result = await TransactionRepository.createTransaction(transaction);
    return result;
  }

  Future<List<String>> getDivision(String query) async {
    final result = await TransactionRepository.getDivision(query: query);
    return result;
  }

  Future<List<String>> getTakeBy(String query) async {
    final result = await TransactionRepository.getTakeBy(query);
    return result;
  }

  Future<List<String>> getDistributor(String query) async {
    final result = await TransactionRepository.getDistributor(query);
    return result;
  }
  Future<List<String>> getAuditor(String query) async {
    final result = await TransactionRepository.getAuditor(query);
    return result;
  }

  void getAllTransactionList({int? dateStart, int? dateEnd}) {
    dateStart ??= getDateStart();
    dateEnd ??= getDateEnd();
    getEntryTransaction(dateStart: dateStart, dateEnd: dateEnd);
    getOutTransaction(dateStart: dateStart, dateEnd: dateEnd);
    getAuditTransaction(dateStart: dateStart, dateEnd: dateEnd);
  }

  void getEntryTransaction({int? dateStart, int? dateEnd}) {
    TransactionRepository.getGroupTransactionByDate(
            type: TransactionType.entry, dateStart: dateStart, dateEnd: dateEnd)
        .then((value) {
      entryTransactionList.update((val) {
        entryTransactionList.value = value;
      });
    });
  }

  void getOutTransaction({int? dateStart, int? dateEnd}) {
    TransactionRepository.getGroupTransactionByDate(
            type: TransactionType.out, dateStart: dateStart, dateEnd: dateEnd)
        .then((value) {
      outTransactionList.update((val) {
        outTransactionList.value = value;
      });
    });
  }

  void getAuditTransaction({int? dateStart, int? dateEnd}) {
    TransactionRepository.getGroupTransactionByDate(
            type: TransactionType.audit, dateStart: dateStart, dateEnd: dateEnd)
        .then((value) {
      auditTransactionList.update((val) {
        auditTransactionList.value = value;
      });
    });
  }
}
