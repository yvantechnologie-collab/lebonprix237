import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/devis.dart';
import '../../providers/devis_provider.dart';
import '../../providers/client_provider.dart';

class DevisFormScreen extends StatefulWidget {
  const DevisFormScreen({super.key});

  @override
  State<DevisFormScreen> createState() => _DevisFormScreenState();
}

class _DevisFormScreenState extends State<DevisFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionCtrl = TextEditingController();
  final _montantCtrl = TextEditingController();
  int? _clientId;
  String? _numeroPreview;

  @override
  void initState() {
    super.initState();
    context.read<DevisProvider>().genererNumero().then((n) {
      setState(() => _numeroPreview = n);
    });
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    if (_clientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un client')),
      );
      return;
    }

    final numero = await context.read<DevisProvider>().genererNumero();

    await context.read<DevisProvider>().addDevis(Devis(
          numero: numero,
          clientId: _clientId!,
          description: _descriptionCtrl.text.trim(),
          montant: double.tryParse(_montantCtrl.text.trim()) ?? 0,
          date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
        ));

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final clients = context.watch<ClientProvider>().clients;

    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau devis')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_numeroPreview != null)
                Text('Numéro: $_numeroPreview', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Client'),
                items: clients
                    .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nom)))
                    .toList(),
                onChanged: (v) => setState(() => _clientId = v),
                value: _clientId,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionCtrl,
                decoration: const InputDecoration(labelText: 'Description de la prestation'),
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Description requise' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _montantCtrl,
                decoration: const InputDecoration(labelText: 'Montant (FCFA)'),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || double.tryParse(v) == null) ? 'Montant invalide' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _enregistrer,
                child: const Text('CRÉER LE DEVIS'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
