import 'package:flutter/material.dart';

import '../services/vault_service.dart';
import '../widgets/sidebar.dart';

const Color _kVaultAccent = Color.fromARGB(255, 56, 56, 56);
const Color _kBackgroundColor = Color(0xFFE5E5E5);
const Color _kTextSub = Color(0xFF666666);

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  final VaultService _vaultService = VaultService();

  // Stores the digits entered by the user.
  final List<String> _enteredCode = [];

  // Required passcode length.
  static const int _codeLength = 4;

  // Stores the first passcode during initial setup.
  List<String> _firstEntry = [];

  bool _hasError = false;
  bool _isFirstTime = false;
  bool _isConfirming = false;
  bool _isLoading = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initVault();
  }

  @override
  void dispose() {
    _enteredCode.clear();
    _firstEntry.clear();

    super.dispose();
  }

  /// Checks whether a vault passcode already exists.
  Future<void> _initVault() async {
    try {
      final existing = await _vaultService.getPasscode();

      if (!mounted) return;

      setState(() {
        _isFirstTime = existing == null;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      debugPrint('Failed to initialize vault: $e');

      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  /// Handles keypad input.
  void _onKeyTap(String value) {
    if (_isProcessing) return;
    if (_enteredCode.length >= _codeLength) return;

    setState(() {
      _hasError = false;
      _enteredCode.add(value);
    });

    if (_enteredCode.length == _codeLength) {
      if (_isFirstTime) {
        _handleSetPasscode();
      } else {
        _checkCode();
      }
    }
  }

  /// Handles initial passcode creation and confirmation.
  Future<void> _handleSetPasscode() async {
    if (_isProcessing) return;

    final entered = _enteredCode.join();

    // First passcode entry.
    if (!_isConfirming) {
      setState(() {
        _firstEntry = List<String>.from(_enteredCode);
        _enteredCode.clear();
        _isConfirming = true;
      });

      return;
    }

    // Confirm the second entry against the first entry.
    if (entered != _firstEntry.join()) {
      _handleIncorrectConfirmation();
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      await _vaultService.setPasscode(entered);

      if (!mounted) return;

      _enteredCode.clear();

      setState(() {
        _isProcessing = false;
      });

      _openUnlockedVault();
    } catch (e) {
      if (!mounted) return;

      debugPrint('Failed to set vault passcode: $e');

      setState(() {
        _isProcessing = false;
        _hasError = true;
      });
    }
  }

  /// Handles an incorrect passcode confirmation during setup.
  void _handleIncorrectConfirmation() {
    setState(() {
      _hasError = true;
    });

    Future.delayed(
      const Duration(milliseconds: 600),
      () {
        if (!mounted) return;

        setState(() {
          _enteredCode.clear();
          _firstEntry.clear();
          _isConfirming = false;
          _hasError = false;
        });
      },
    );
  }

  /// Deletes the last entered digit.
  void _onDelete() {
    if (_isProcessing) return;
    if (_enteredCode.isEmpty) return;

    setState(() {
      _hasError = false;
      _enteredCode.removeLast();
    });
  }

  /// Verifies an existing vault passcode.
  Future<void> _checkCode() async {
    if (_isProcessing) return;

    final entered = _enteredCode.join();

    setState(() {
      _isProcessing = true;
    });

    try {
      final isCorrect =
          await _vaultService.verifyPasscode(entered);

      if (!mounted) return;

      if (isCorrect) {
        _enteredCode.clear();

        setState(() {
          _isProcessing = false;
        });

        _openUnlockedVault();
      } else {
        setState(() {
          _isProcessing = false;
          _hasError = true;
        });

        Future.delayed(
          const Duration(milliseconds: 600),
          () {
            if (!mounted) return;

            setState(() {
              _enteredCode.clear();
              _hasError = false;
            });
          },
        );
      }
    } catch (e) {
      if (!mounted) return;

      debugPrint('Failed to verify vault passcode: $e');

      setState(() {
        _isProcessing = false;
        _hasError = true;
      });
    }
  }

  /// Opens the current placeholder unlocked-vault screen.
  ///
  /// The actual private notes/folders screen can replace this later
  /// without changing the passcode logic.
  void _openUnlockedVault() {
    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Vault'),
            ),
            body: const Center(
              child: Text('Vault Unlocked 🔓'),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _kBackgroundColor,

      drawer: const AppSidebar(),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.grid_view_rounded,
            size: 28,
            color: _kTextSub,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text('Vault'),
      ),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 48,
              color: _kVaultAccent,
            ),

            const SizedBox(height: 12),

            Text(
              _isFirstTime
                  ? (_isConfirming
                      ? 'Confirm Passcode'
                      : 'Set Passcode')
                  : 'Enter Passcode',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 32),

            _buildDots(),

            if (_hasError) ...[
              const SizedBox(height: 16),

              Text(
                _isFirstTime
                    ? 'Passcodes do not match'
                    : 'Incorrect passcode',
                style: const TextStyle(
                  color: _kVaultAccent,
                  fontSize: 14,
                ),
              ),
            ],

            const SizedBox(height: 48),

            _buildKeypad(),
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _codeLength,
        (index) {
          final filled = index < _enteredCode.length;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hasError
                  ? _kVaultAccent
                  : filled
                      ? _kVaultAccent
                      : Colors.transparent,
              border: Border.all(
                color: _hasError
                    ? _kVaultAccent
                    : _kTextSub,
                width: 2,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'del'],
    ];

    return Column(
      children: keys.map(
        (row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map(
              (key) {
                if (key.isEmpty) {
                  return const SizedBox(
                    width: 90,
                    height: 70,
                  );
                }

                if (key == 'del') {
                  return _KeyButton(
                    showBorder: false,
                    onTap: _onDelete,
                    child: const Icon(
                      Icons.backspace_outlined,
                      color: _kTextSub,
                    ),
                  );
                }

                return _KeyButton(
                  onTap: () => _onKeyTap(key),
                  child: Text(
                    key,
                    style: const TextStyle(
                      fontSize: 26,
                    ),
                  ),
                );
              },
            ).toList(),
          );
        },
      ).toList(),
    );
  }
}

class _KeyButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final bool showBorder;

  const _KeyButton({
    required this.onTap,
    required this.child,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 70,
        alignment: Alignment.center,
        child: Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: showBorder
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _kTextSub.withOpacity(0.4),
                    width: 1.5,
                  ),
                )
              : null,
          child: child,
        ),
      ),
    );
  }
}