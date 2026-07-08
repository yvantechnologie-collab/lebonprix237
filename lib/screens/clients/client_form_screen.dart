import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/client.dart';
import '../../providers/client_provider.dart';

class ClientFormScreen extends StatefulWidget {
  final Client? client;
  const ClientFormScreen({super.key, this.client});

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomCtrl;
  late TextEditingController _telCtrl;
  late TextEditingController _whatsappCtrl;
  late TextEditingController _adresseCtrl;

  @override
  void initState() {
    super.initState();
    _nomCtrl = TextEditingController(text: widget.client?.nom ?? '');
    _telCtrl = TextEditingController(text: widget.client?.telephone ?? '');
    _whatsappCtrl = TextEditingController(text: widget.client?.whatsapp ?? '');
    _adresseCtrl = TextEditingController(text: widget.client?.adresse ?? '');
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ClientProvider>();

    if (widget.client == null) {
      await provider.addClient(Client(
        nom: _nomCtrl.text.trim(),
        telephone: _telCtrl.text.trim(),
        whatsapp: _whatsappCtrl.text.trim(),
        adresse: _adresseCtrl.text.trim(),
        dateCreation: DateTime.now().toIso8601String(),
      ));
    } else {
      await provider.updateClient(Client(
        id: widget.client!.id,
        nom: _nomCtrl.text.trim(),
        telephone: _telCtrl.text.trim(),
        whatsapp: _whatsappCtrl.text.trim(),
        adresse: _adresseCtrl.text.trim(),
        dateCreation: widget.client!.dateCreation,
      ));
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.client == null ? 'Nouveau client' : 'Modifier le client'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(labelText: 'Nom complet'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Nom requis' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _telCtrl,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _whatsappCtrl,
                decoration: const InputDecoration(labelText: 'WhatsApp'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _adresseCtrl,
                decoration: const InputDecoration(labelText: 'Adresse'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _enregistrer,
                child: const Text('ENREGISTRER'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
