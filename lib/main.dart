import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  runApp(const FKeepOnApp());
}

class FKeepOnApp extends StatelessWidget {
  const FKeepOnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'f.keepon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B519D), // line seed jp inspired purple
          brightness: Brightness.dark,
        ),
      ),
      home: const KeepOnScreen(),
    );
  }
}

class KeepOnScreen extends StatefulWidget {
  const KeepOnScreen({super.key});

  @override
  State<KeepOnScreen> createState() => _KeepOnScreenState();
}

class _KeepOnScreenState extends State<KeepOnScreen> {
  bool _isKeepOnActive = false;

  @override
  void initState() {
    super.initState();
    _checkWakelockStatus();
  }

  Future<void> _checkWakelockStatus() async {
    final enabled = await WakelockPlus.enabled;
    setState(() {
      _isKeepOnActive = enabled;
    });
  }

  void _toggleWakelock(bool value) async {
    if (value) {
      await WakelockPlus.enable();
    } else {
      await WakelockPlus.disable();
    }
    setState(() {
      _isKeepOnActive = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'f.keepon',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isKeepOnActive ? Icons.lightbulb : Icons.lightbulb_outline,
                size: 72,
                color: _isKeepOnActive ? const Color(0xFFB388FF) : Colors.grey,
              ),
              const SizedBox(height: 24),
              Text(
                _isKeepOnActive ? 'wakelock is active' : 'wakelock is disabled',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isKeepOnActive
                    ? 'your screen will stay awake as long as this app is open.'
                    : 'toggle the switch below to prevent your screen from sleeping.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 40),
              Switch.adaptive(
                value: _isKeepOnActive,
                onChanged: _toggleWakelock,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
