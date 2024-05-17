import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class UtilsServices {
  final storage = const FlutterSecureStorage();
  //salvar dado localmente em segurança
  Future<void> saveLocalDate(
      {required String key, required String date}) async {
    await storage.write(key: key, value: date);
  }

  //Recuperar dado salvo localmente em segurança
  Future<String?> getLocalDate({required String key}) async {
    return await storage.read(key: key);
  }

  //remover dado salvo localmente
  Future<void> removeLocalData({required String key}) async {
    await storage.delete(key: key);
  }

  //região de moeda
  String priceToCurrency(double price) {
    NumberFormat numberFormat = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return numberFormat.format(price);
  }

  String formatDateTime(DateTime dateTime) {
    initializeDateFormatting();
    DateFormat dateFormat = DateFormat.yMd('pt_BR').add_Hm();
    return dateFormat.format(dateTime);
  }

  void showToast({
    required String message,
    bool isError = false,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: isError ? Colors.red : Colors.white,
      textColor: isError ? Colors.white : Colors.black,
      fontSize: 14,
    );
  }
}
