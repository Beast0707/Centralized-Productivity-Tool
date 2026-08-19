import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../services/vault_service.dart';

const Color _kVaultAccent = Color.fromARGB(255, 56, 56, 56);
const Color _kBackgroundColor = Color(0xFFE5E5E5);
const Color _kTextSub = Color(0xFF666666);

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Stores the digits entered by the user
  final List<String> _enteredCode = [];

  // Required length of passcode
  final int _codeLength = 4;

  bool _hasError = false;      // Indicates incorrect passcode
  bool _isFirstTime = false;   // True if no passcode is set yet
  bool _isConfirming = false;  // True when confirming passcode
  bool _isLoading = true;      // Loading state during initialization

  // Temporarily stores first passcode entry during setup
  List<String> _firstEntry = [];

  // Service handling vault operations
  final VaultService _vaultService = VaultService(); 

  @override
  void initState() {
    super.initState();
    _initVault();
  }

  // Initialize vault by checking if passcode already exists
  void _initVault() async {
    final existing = await _vaultService.getPasscode();

    setState(() {
      _isFirstTime = existing == null;
      _isLoading = false;
    });
  }

  // Handles keypad input
  void _onKeyTap(String value) {
    if (_enteredCode.length >= _codeLength) return;

    setState(() {
      _hasError = false;
      _enteredCode.add(value);
    });

    // When required digits entered, process accordingly
    if (_enteredCode.length == _codeLength) {
      if (_isFirstTime) {
        _handleSetPasscode();
      } else {
        _checkCode();
      }
    }
  }

  // Handles passcode creation and confirmation
  void _handleSetPasscode() async {
    final entered = _enteredCode.join();

    // First entry of passcode
    if (!_isConfirming) {
      _firstEntry = List.from(_enteredCode);

      setState(() {
        _enteredCode.clear();
        _isConfirming = true;
      });
    } else {
      // Confirm passcode matches first entry
      if (entered == _firstEntry.join()) {
        await _vaultService.setPasscode(entered);

        _enteredCode.clear();

        // Navigate to unlocked screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text("Vault")),
              body: const Center(child: Text("Vault Unlocked ")),
            ),
          ),
        );
      } else {
        // Passcodes do not match
        setState(() {
          _hasError = true;
        });

        // Reset after short delay
        Future.delayed(const Duration(milliseconds: 600), () {
          setState(() {
            _enteredCode.clear();
            _firstEntry.clear();
            _isConfirming = false;
            _hasError = false;
          });
        });
      }
    }
  }

  // Deletes last entered digit
  void _onDelete() {
    if (_enteredCode.isEmpty) return;

    setState(() {
      _hasError = false;
      _enteredCode.removeLast();
    });
  }

  // Verifies entered passcode
  void _checkCode() async {
    final entered = _enteredCode.join();

    final isCorrect = await _vaultService.verifyPasscode(entered);

    if (isCorrect) {
      _enteredCode.clear();

      // Navigate to unlocked screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text("Vault")),
            body: const Center(child: Text("Vault Unlocked 🔓")),
          ),
        ),
      );
    } else {
      // Incorrect passcode
      setState(() => _hasError = true);

      // Reset input after delay
      Future.delayed(const Duration(milliseconds: 600), () {
        setState(() {
          _enteredCode.clear();
          _hasError = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loader while initializing
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _kBackgroundColor,
      drawer: const AppSidebar(currentRoute: '/vault'),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,

        // Drawer button
        leading: IconButton(
          icon: const Icon(Icons.grid_view_rounded, size: 28, color: _kTextSub),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text("Vault"),
      ),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 48, color: _kVaultAccent),
            const SizedBox(height: 12),

            // Instruction text
            Text(
              _isFirstTime
                  ? (_isConfirming ? 'Confirm Passcode' : 'Set Passcode')
                  : 'Enter Passcode',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 32),

            // Passcode dots
            _buildDots(),

            if (_hasError) ...[
              const SizedBox(height: 16),
              Text(
                _isFirstTime
                    ? 'Passcodes do not match'
                    : 'Incorrect passcode',
                style: const TextStyle(color: _kVaultAccent, fontSize: 14),
              ),
            ],

            const SizedBox(height: 48),

            _buildKeypad(),
          ],
        ),
      ),
    );
  }

  // Builds passcode indicator dots
  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_codeLength, (i) {
        final filled = i < _enteredCode.length;

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
              color: _hasError ? _kVaultAccent : _kTextSub,
              width: 2,
            ),
          ),
        );
      }),
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
      children: keys.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((key) {
            if (key.isEmpty) return const SizedBox(width: 90, height: 70);

            // Delete button
            if (key == 'del') {
              return _KeyButton(
                showBorder: false,
                onTap: _onDelete,
                child: const Icon(Icons.backspace_outlined, color: _kTextSub),
              );
            }

            // Number button
            return _KeyButton(
              onTap: () => _onKeyTap(key),
              child: Text(
                key,
                style: const TextStyle(fontSize: 26),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

// Reusable keypad button widget
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