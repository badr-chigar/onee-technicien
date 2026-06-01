import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../services/api_service.dart';
import '../models/intervention.dart';
import '../widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.api});
  final ApiService api;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Intervention>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.api.getInterventions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<Intervention>>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snap.data!;
          final aujourdhui = list
              .where((i) => _memeJour(i.datePrevue, DateTime.now()))
              .length;
          final enCours =
              list.where((i) => i.statut == StatutIntervention.enCours).length;
          final terminees =
              list.where((i) => i.statut == StatutIntervention.terminee).length;
          final urgentes =
              list.where((i) => i.priorite == 'Haute').toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bonjour, Technicien',
                    style: TextStyle(fontSize: 14, color: OneeColors.textMuted)),
                const SizedBox(height: 2),
                Text(
                    DateFormat('EEEE d MMMM yyyy', 'fr_FR')
                        .format(DateTime.now()),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                        child: StatCard(
                            valeur: '$aujourdhui',
                            libelle: 'Aujourd\'hui',
                            icone: Icons.today,
                            couleur: OneeColors.primary)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: StatCard(
                            valeur: '$enCours',
                            libelle: 'En cours',
                            icone: Icons.bolt,
                            couleur: OneeColors.accent)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: StatCard(
                            valeur: '$terminees',
                            libelle: 'Terminées',
                            icone: Icons.check_circle_outline,
                            couleur: OneeColors.success)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: StatCard(
                            valeur: '${urgentes.length}',
                            libelle: 'Priorité haute',
                            icone: Icons.priority_high,
                            couleur: OneeColors.danger)),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Interventions urgentes',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ...urgentes.map((i) => Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFFCEAEA),
                          child: Icon(Icons.warning_amber_rounded,
                              color: OneeColors.danger),
                        ),
                        title: Text(i.type,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('${i.clientNom} · ${i.ville}'),
                        trailing: Text(i.reference,
                            style: const TextStyle(
                                fontSize: 11, color: OneeColors.textMuted)),
                      ),
                    )),
                if (urgentes.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('Aucune intervention urgente.',
                        style: TextStyle(color: OneeColors.textMuted)),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _memeJour(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
