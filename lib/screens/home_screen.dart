import 'package:flutter/material.dart';
import '../main.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';
import 'interventions_screen.dart';
import 'compteurs_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.api});
  final ApiService api;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(api: widget.api),
      InterventionsScreen(api: widget.api),
      CompteursScreen(api: widget.api),
    ];
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: Colors.white,
        indicatorColor: OneeColors.primary.withOpacity(0.12),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: OneeColors.primary),
            label: 'Tableau',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment, color: OneeColors.primary),
            label: 'Interventions',
          ),
          NavigationDestination(
            icon: Icon(Icons.speed_outlined),
            selectedIcon: Icon(Icons.speed, color: OneeColors.primary),
            label: 'Compteurs',
          ),
        ],
      ),
    );
  }
}
