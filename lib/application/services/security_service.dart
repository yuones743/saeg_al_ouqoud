import 'dart:convert';
import 'package:crypto/crypto.dart';

class SecurityService {
  static String sha256Hash(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  static String sanitize(String input) {
    return input.replaceAll(RegExp(r'[<>&\'"`]'), '');
  }

  static bool isSafeFileName(String name) {
    return !name.contains(RegExp(r'[\\/:*?"<>|]'));
  }
}