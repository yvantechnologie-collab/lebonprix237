import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/stock_provider.dart';
import 'stock_form_screen.dart';

class StockListScreen extends StatelessWidget {
  const StockListScreen({super.key});

  void _dialogueMouvement(BuildContext context, int itemId, bool entree) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(entree ? 'Entrée de stock' : 'Sortie de stock'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Quantité'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          TextButton(
            onPressed: () async {
              final qte = double.tryParse(ctrl.text) ?? 0;
              if (qte > 0) {
                await context.read<StockProvider>().mouvementStock(itemId, entree ? qte : -qte);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StockProvider>();

    return Scaffold(
      body: provider.stock.isEmpty
          ? const Center(child: Text('Aucun article en stock'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.stock.length,
              itemBuilder: (context, i) {
                final item = provider.stock[i];
                return Card(
                  color: item.enAlerte ? Colors.orange[50] : null,
                  child: ListTile(
                    title: Text(item.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${item.categorie} • ${item.quantite.toStringAsFixed(0)} ${item.unite}'
                        '${item.enAlerte ? " ⚠️ Stock faible" : ""}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: AppColors.vertSucces),
                          tooltip: 'Entrée',
                          onPressed: () => _dialogueMouvement(context, item.id!, true),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                          tooltip: 'Sortie',
                          onPressed: () => _dialogueMouvement(context, item.id!, false),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const StockFormScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
