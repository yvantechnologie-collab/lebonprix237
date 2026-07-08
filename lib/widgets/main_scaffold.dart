import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../screens/dashboard_screen.dart';
import '../screens/clients/client_list_screen.dart';
import '../screens/devis/devis_list_screen.dart';
import '../screens/factures/facture_list_screen.dart';
import '../screens/stock/stock_list_screen.dart';
import '../screens/login_screen.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;
  const MainScaffold({super.key, this.initialIndex = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _index;

  final List<_NavItem> _items = const [
    _NavItem('Tableau de bord', Icons.dashboard, DashboardBody()),
    _NavItem('Clients', Icons.people, ClientListScreen()),
    _NavItem('Devis', Icons.description, DevisListScreen()),
    _NavItem('Factures', Icons.receipt_long, FactureListScreen()),
    _NavItem('Stock', Icons.inventory_2, StockListScreen()),
  ];

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_items[_index].titre),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () {
              auth.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                color: AppColors.noir,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Lebonprix 237',
                        style: TextStyle(
                            color: AppColors.blanc,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const Text('by Elite Empire SARL',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 8),
                    Text(
                      auth.currentUser?.nom ?? '',
                      style: const TextStyle(color: AppColors.rouge),
                    ),
                    Text(
                      auth.currentUser?.estAdmin == true ? 'Administrateur' : 'Employé',
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              for (int i = 0; i < _items.length; i++)
                ListTile(
                  leading: Icon(_items[i].icone,
                      color: _index == i ? AppColors.rouge : Colors.grey[700]),
                  title: Text(_items[i].titre,
                      style: TextStyle(
                          color: _index == i ? AppColors.rouge : AppColors.noir,
                          fontWeight: _index == i ? FontWeight.bold : FontWeight.normal)),
                  selected: _index == i,
                  onTap: () {
                    setState(() => _index = i);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
      body: _items[_index].ecran,
    );
  }
}

class _NavItem {
  final String titre;
  final IconData icone;
  final Widget ecran;
  const _NavItem(this.titre, this.icone, this.ecran);
}
