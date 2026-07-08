import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/client_provider.dart';
import '../providers/devis_provider.dart';
import '../providers/facture_provider.dart';
import '../providers/stock_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/main_scaffold.dart';

/// Point d'entrée après connexion : englobe la navigation (drawer)
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainScaffold(initialIndex: 0);
  }
}

/// Contenu réel du tableau de bord (affiché dans MainScaffold)
class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      Future.microtask(() {
        context.read<ClientProvider>().loadClients();
        context.read<DevisProvider>().loadDevis();
        context.read<FactureProvider>().loadFactures();
        context.read<StockProvider>().loadStock();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final clients = context.watch<ClientProvider>().clients;
    final devis = context.watch<DevisProvider>().devis;
    final factures = context.watch<FactureProvider>();
    final stock = context.watch<StockProvider>();

    final benefice = factures.totalEncaisse; // simplifié pour la version de base

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<ClientProvider>().loadClients();
        await context.read<DevisProvider>().loadDevis();
        await context.read<FactureProvider>().loadFactures();
        await context.read<StockProvider>().loadStock();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              StatCard(
                titre: 'Commandes / Devis',
                valeur: '${devis.length}',
                icone: Icons.description,
              ),
              StatCard(
                titre: 'Clients',
                valeur: '${clients.length}',
                icone: Icons.people,
                couleur: AppColors.noir,
              ),
              StatCard(
                titre: 'Chiffre d\'affaires',
                valeur: '${factures.chiffreAffairesTotal.toStringAsFixed(0)} F',
                icone: Icons.attach_money,
                couleur: AppColors.vertSucces,
              ),
              StatCard(
                titre: 'Encaissé',
                valeur: '${benefice.toStringAsFixed(0)} F',
                icone: Icons.savings,
                couleur: AppColors.orangeAlerte,
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (stock.alertes.isNotEmpty) ...[
            const Text('⚠️ Alertes de stock',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ...stock.alertes.map((item) => Card(
                  color: Colors.orange[50],
                  child: ListTile(
                    leading: const Icon(Icons.warning_amber, color: AppColors.orangeAlerte),
                    title: Text(item.nom),
                    subtitle: Text('Stock restant: ${item.quantite.toStringAsFixed(0)} ${item.unite}'),
                  ),
                )),
          ] else
            const Card(
              child: ListTile(
                leading: Icon(Icons.check_circle, color: AppColors.vertSucces),
                title: Text('Aucune alerte de stock'),
              ),
            ),
        ],
      ),
    );
  }
}
