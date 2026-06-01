import 'package:flutter/material.dart';
import '../main.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _matriculeCtrl = TextEditingController(text: 'TC-2041');
  final _mdpCtrl = TextEditingController(text: '••••••');
  final _api = ApiService();
  bool _loading = false;
  String? _erreur;

  Future<void> _connexion() async {
    setState(() {
      _loading = true;
      _erreur = null;
    });
    final ok = await _api.login(_matriculeCtrl.text, _mdpCtrl.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen(api: _api)),
      );
    } else {
      setState(() => _erreur = 'Matricule ou mot de passe incorrect.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [OneeColors.primary, OneeColors.primaryDark],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(Icons.bolt_rounded,
                        size: 52, color: OneeColors.accent),
                  ),
                  const SizedBox(height: 18),
                  const Text('ONEE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4)),
                  const Text('Espace Technicien',
                      style: TextStyle(color: Colors.white70, fontSize: 15)),
                  const SizedBox(height: 34),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Connexion',
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 18),
                          TextField(
                            controller: _matriculeCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Matricule',
                              prefixIcon: Icon(Icons.badge_outlined),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _mdpCtrl,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Mot de passe',
                              prefixIcon: Icon(Icons.lock_outline),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          if (_erreur != null) ...[
                            const SizedBox(height: 12),
                            Text(_erreur!,
                                style: const TextStyle(
                                    color: OneeColors.danger, fontSize: 13)),
                          ],
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _loading ? null : _connexion,
                            child: _loading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2.4, color: Colors.white))
                                : const Text('Se connecter',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text('Office National de l\'Électricité et de l\'Eau',
                      style: TextStyle(color: Colors.white60, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
