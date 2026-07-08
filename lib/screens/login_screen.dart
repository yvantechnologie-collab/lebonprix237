import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifiantCtrl = TextEditingController();
  final _motDePasseCtrl = TextEditingController();
  bool _loading = false;
  String? _erreur;
  bool _obscure = true;

  Future<void> _seConnecter() async {
    setState(() {
      _loading = true;
      _erreur = null;
    });

    final auth = context.read<AuthProvider>();
    final erreur = await auth.login(
      _identifiantCtrl.text.trim(),
      _motDePasseCtrl.text.trim(),
    );

    setState(() {
      _loading = false;
      _erreur = erreur;
    });

    if (erreur == null && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.noir,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.blanc,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.rouge, width: 3),
                  ),
                  child: const Icon(Icons.photo_camera_back,
                      color: AppColors.rouge, size: 44),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Lebonprix 237',
                  style: TextStyle(
                    color: AppColors.blanc,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'MANAGER',
                  style: TextStyle(
                    color: AppColors.rouge,
                    fontSize: 14,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 36),
                TextField(
                  controller: _identifiantCtrl,
                  style: const TextStyle(color: AppColors.noir),
                  decoration: const InputDecoration(
                    hintText: 'Identifiant',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _motDePasseCtrl,
                  obscureText: _obscure,
                  style: const TextStyle(color: AppColors.noir),
                  decoration: InputDecoration(
                    hintText: 'Mot de passe',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  onSubmitted: (_) => _seConnecter(),
                ),
                if (_erreur != null) ...[
                  const SizedBox(height: 12),
                  Text(_erreur!, style: const TextStyle(color: Colors.orangeAccent)),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _seConnecter,
                    child: _loading
                        ? const SizedBox(
                            height: 20, width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('SE CONNECTER'),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Identifiant par défaut : admin / admin237',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
