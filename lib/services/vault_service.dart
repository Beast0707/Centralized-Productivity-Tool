import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VaultService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _key = 'vault_passcode';

  Future<void> setPasscode(String code) async {
    await _storage.write(key: _key, value: code);
  }

  Future<String?> getPasscode() async {
    return await _storage.read(key: _key);
  }

  Future<bool> verifyPasscode(String entered) async {
    final saved = await getPasscode();
    return saved == entered;
  }
}
