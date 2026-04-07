import 'package:flutter/material.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> _enteredCode = [];
  final int _codeLength = 4;
  bool _hasError = false;

  final String _correctCode = '0000';

  void _onKeyTap(String value) {
    if (_enteredCode.length >= _codeLength) return;
    setState(() {
      _hasError = false;
      _enteredCode.add(value);
    });

    if (_enteredCode.length == _codeLength) {
      _checkCode();
    }
  }

  void _onDelete() {
    if (_enteredCode.isEmpty) return;
    setState(() {
      _hasError = false;
      _enteredCode.removeLast();
    });
  }

  void _checkCode() {
    final entered = _enteredCode.join();
    if (entered == _correctCode) {
      debugPrint('Correct passcode!');
    } else {
      setState(() => _hasError = true);
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _kBackgroundColor,
      drawer: const AppSidebar(currentRoute: '/vault'),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 48, color: _kVaultAccent),
                  const SizedBox(height: 12),
                  const Text(
                    'Enter Passcode',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildDots(),
                  if (_hasError) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Incorrect passcode',
                      style: TextStyle(color: _kVaultAccent, fontSize: 14),
                    ),
                  ],
                  const SizedBox(height: 48),
                  _buildKeypad(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.grid_view_rounded, size: 28, color: _kTextSub),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ],
      ),
    );
  }

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
            if (key == 'del') {
              return _KeyButton(
                showBorder: false,
                onTap: _onDelete,
                child: const Icon(Icons.backspace_outlined, color: _kTextSub, size: 22),
              );
            }
            return _KeyButton(
              onTap: () => _onKeyTap(key),
              child: Text(
                key,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w400, color: Colors.black87),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _KeyButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final bool showBorder;

  const _KeyButton({required this.onTap, required this.child, this.showBorder = true});

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