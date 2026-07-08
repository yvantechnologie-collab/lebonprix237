import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/devis_provider.dart';
import '../../providers/client_provider.dart';
import '../../services/pdf_service.dart';
import 'devis_form_screen.dart';

class DevisListScreen extends StatelessWidget {
  const DevisListScreen({super.key});

  Color _couleurStatut(String statut) {
    switch (statut) {
      case 'accepte':
        return AppColors.vertSucces;
      case 'refuse':
        return Colors.redAccent;
      default:
        return AppColors.orangeAlerte;
    }
  }

  @override
  Widget build(BuildContext context) {
    final devisProvider = context.watch<DevisProvider>();
    final clientProvider = context.watch<ClientProvider>();

    return Scaffold(
      body: devisProvider.devis.isEmpty
          ? const Center(child: Text('Aucun devis pour le moment'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: devisProvider.devis.length,
              itemBuilder: (context, i) {
                final devis = devisProvider.devis[i];
                final client = clientProvider.getById(devis.clientId);

                return Card(
                  child: ListTile(
                    title: Text(devis.numero, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${client?.nom ?? "Client inconnu"} • ${devis.montant.toStringAsFixed(0)} FCFA'),
                    leading: Chip(
                      label: Text(devis.statutLabel, style: const TextStyle(fontSize: 11, color: Colors.white)),
                      backgroundColor: _couleurStatut(devis.statut),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'pdf' && client != null) {
                          await PdfService.genererDevisPdf(devis, client);
                        } else if (value == 'accepte' || value == 'refuse' || value == 'en_attente') {
                          await context.read<DevisProvider>().updateStatut(devis.id!, value);
                        } else if (value == 'supprimer') {
                          await context.read<DevisProvider>().deleteDevis(devis.id!);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'pdf', child: Text('📄 Générer PDF')),
                        PopupMenuItem(value: 'accepte', child: Text('✅ Marquer accepté')),
                        PopupMenuItem(value: 'refuse', child: Text('❌ Marquer refusé')),
                        PopupMenuItem(value: 'supprimer', child: Text('🗑️ Supprimer')),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DevisFormScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
