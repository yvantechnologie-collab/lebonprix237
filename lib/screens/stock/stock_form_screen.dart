import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/stock_item.dart';
import '../../providers/stock_provider.dart';

class StockFormScreen extends StatefulWidget {
  const StockFormScreen({super.key});

  @override
  State<StockFormScreen> createState() => _StockFormScreenState();
}

class _StockFormScreenState extends State<StockFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _quantiteCtrl = TextEditingController();
  final _seuilCtrl = TextEditingController(text: '5');
  String _categorie = 'Matière première';
  String _unite = 'unité';

  final List<String> _categories = const [
    'Matière première', 'Emballage', 'Accessoire', 'Outil', 'Autre'
  ];
  final List<String> _unites = const ['unité', 'kg', 'g', 'm', 'litre', 'rouleau', 'feuille'];

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;

    await context.read<StockProvider>().addItem(StockItem(
          nom: _nomCtrl.text.trim(),
          categorie: _categorie,
          quantite: double.tryParse(_quantiteCtrl.text) ?? 0,
          unite: _unite,
          seuilMinimum: double.tryParse(_seuilCtrl.text) ?? 0,
          dateMaj: DateTime.now().toIso8601String(),
        ));

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvel article de stock')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(labelText: 'Nom de l\'article'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Nom requis' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _categorie,
                decoration: const InputDecoration(labelText: 'Catégorie'),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _categorie = v!),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantiteCtrl,
                      decoration: const InputDecoration(labelText: 'Quantité initiale'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _unite,
                      decoration: const InputDecoration(labelText: 'Unité'),
                      items: _unites.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                      onChanged: (v) => setState(() => _unite = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _seuilCtrl,
                decoration: const InputDecoration(labelText: 'Seuil minimum (alerte)'),
                keyboardType: TextInputType.number,
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
