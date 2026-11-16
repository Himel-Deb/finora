
import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

class PasswordService {
  static final Pbkdf2 _algorithm = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000,
    bits: 256,
  );

  // Password Hash
  static Future<String> hashPassword(String password) async {
    final random = Random.secure();

    final salt = List<int>.generate(
      16,
      (_) => random.nextInt(256),
    );

    final key = await _algorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );

    final hash = await key.extractBytes();

    return '${base64Encode(salt)}:${base64Encode(hash)}';
  }

  // Verify Password
  static Future<bool> verifyPassword(
    String password,
    String storedHash,
  ) async {
    try {
      final parts = storedHash.split(':');

      if (parts.length != 2) {
        return false;
      }

      final salt = base64Decode(parts[0]);
      final originalHash = base64Decode(parts[1]);

      final key = await _algorithm.deriveKey(
        secretKey: SecretKey(utf8.encode(password)),
        nonce: salt,
      );

      final newHash = await key.extractBytes();

      if (newHash.length != originalHash.length) {
        return false;
      }

      var difference = 0;

      for (var i = 0; i < newHash.length; i++) {
        difference |= newHash[i] ^ originalHash[i];
      }

      return difference == 0;
    } catch (_) {
      return false;
    }
  }
}
