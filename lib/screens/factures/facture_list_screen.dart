import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../models/facture.dart';
import '../../providers/facture_provider.dart';
import '../../providers/client_provider.dart';
import '../../services/pdf_service.dart';

class FactureListScreen extends StatelessWidget {
  const FactureListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final factureProvider = context.watch<FactureProvider>();
    final clientProvider = context.watch<ClientProvider>();

    return Scaffold(
      body: factureProvider.factures.isEmpty
          ? const Center(child: Text('Aucune facture pour le moment'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: factureProvider.factures.length,
              itemBuilder: (context, i) {
                final facture = factureProvider.factures[i];
                final client = clientProvider.getById(facture.clientId);

                return Card(
                  child: ListTile(
                    title: Text(facture.numero, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        '${client?.nom ?? "Client inconnu"}\nTotal: ${facture.montantTotal.toStringAsFixed(0)} F • Solde: ${facture.soldeRestant.toStringAsFixed(0)} F'),
                    isThreeLine: true,
                    leading: Icon(
                      facture.estSoldee ? Icons.check_circle : Icons.hourglass_bottom,
                      color: facture.estSoldee ? AppColors.vertSucces : AppColors.orangeAlerte,
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'pdf' && client != null) {
                          await PdfService.genererFacturePdf(facture, client);
                        } else if (value == 'payer') {
                          _dialoguePaiement(context, facture);
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'pdf', child: Text('📄 Générer PDF')),
                        if (!facture.estSoldee)
                          const PopupMenuItem(value: 'payer', child: Text('💰 Enregistrer un paiement')),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _dialogueNouvelleFacture(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _dialoguePaiement(BuildContext context, Facture facture) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Paiement - ${facture.numero}'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: 'Montant reçu (FCFA)',
              helperText: 'Solde restant: ${facture.soldeRestant.toStringAsFixed(0)} FCFA'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          TextButton(
            onPressed: () async {
              final montant = double.tryParse(ctrl.text) ?? 0;
              if (montant > 0) {
                await context.read<FactureProvider>().enregistrerPaiement(facture.id!, montant);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  void _dialogueNouvelleFacture(BuildContext context) {
    final clients = context.read<ClientProvider>().clients;
    int? clientId;
    final descCtrl = TextEditingController();
    final montantCtrl = TextEditingController();
    final devisRefCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Nouvelle facture'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Client'),
                  items: clients.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nom))).toList(),
                  onChanged: (v) => setState(() => clientId = v),
                ),
                TextField(controller: devisRefCtrl, decoration: const InputDecoration(labelText: 'Réf. devis (optionnel)')),
                TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
                TextField(
                  controller: montantCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Montant total (FCFA)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Annuler')),
            TextButton(
              onPressed: () async {
                if (clientId == null || montantCtrl.text.isEmpty) return;
                final numero = await context.read<FactureProvider>().genererNumero();
                await context.read<FactureProvider>().addFacture(Facture(
                      numero: numero,
                      clientId: clientId!,
                      devisRef: devisRefCtrl.text.trim(),
                      description: descCtrl.text.trim(),
                      montantTotal: double.tryParse(montantCtrl.text) ?? 0,
                      date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                    ));
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: const Text('Créer'),
            ),
          ],
        ),
      ),
    );
  }
}
