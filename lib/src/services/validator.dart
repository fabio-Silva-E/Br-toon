import 'package:get/get.dart';

String? emailValidator(String? email) {
  if (email == null || email.isEmpty) {
    return 'Digite seu email';
  }
  if (!email.isEmail) return 'Digite um email valido!';
  return null;
}

String? passowrdValidator(password) {
  if (password == null || password.isEmpty) {
    return 'Digite sua senha';
  }
  if (password.length < 7) {
    return 'Digite uma senha pelomenos 7 caracteres';
  }
  return null;
}

String? nameValiadtor(String? name) {
  if (name == null || name.isEmpty) {
    return 'Digite seu nome';
  }
  final names = name.split('');
  if (names.length == 1) return 'digite seu nome completo';
  return null;
}

String? phoneValidator(String? phone) {
  if (phone == null || phone.isEmpty) {
    return 'Digite um celular';
  }
  if (phone.length < 14 || !phone.isPhoneNumber) {
    return 'Digite um numero valido';
  }
  return null;
}

String? cpfValidator(String? cpf) {
  if (cpf == null || cpf.isEmpty) {
    return 'Digite um CPF';
  }
  if (!cpf.isCpf) return 'Digite um CPF valido!';
  return null;
}
