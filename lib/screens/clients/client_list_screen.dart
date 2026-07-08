import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../models/client.dart';
import '../../providers/client_provider.dart';
import 'client_form_screen.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  String _recherche = '';

  Future<void> _ouvrirWhatsapp(String numero) async {
    final numeroClean = numero.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/237$numeroClean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClientProvider>();
    final clients = provider.clients.where((c) {
      final q = _recherche.toLowerCase();
      return c.nom.toLowerCase().contains(q) || c.telephone.contains(q);
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Rechercher un client...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _recherche = v),
            ),
          ),
          Expanded(
            child: clients.isEmpty
                ? const Center(child: Text('Aucun client trouvé'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: clients.length,
                    itemBuilder: (context, i) {
                      final client = clients[i];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.rouge,
                            child: Text(
                              client.nom.isNotEmpty ? client.nom[0].toUpperCase() : '?',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(client.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(client.telephone),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (client.whatsapp.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.chat, color: Colors.green),
                                  onPressed: () => _ouvrirWhatsapp(client.whatsapp),
                                ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.grey),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ClientFormScreen(client: client)),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Supprimer ce client ?'),
                                      content: Text(client.nom),
                                      actions: [
                                        TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Annuler')),
                                        TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('Supprimer')),
                                      ],
                                    ),
                                  );
                                  if (confirm == true && client.id != null) {
                                    await context.read<ClientProvider>().deleteClient(client.id!);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ClientFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
