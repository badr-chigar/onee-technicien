import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../services/api_service.dart';
import '../models/intervention.dart';

class InterventionsScreen extends StatefulWidget {
  const InterventionsScreen({super.key, required this.api});
  final ApiService api;

  @override
  State<InterventionsScreen> createState() => _InterventionsScreenState();
}

class _InterventionsScreenState extends State<InterventionsScreen> {
  late Future<List<Intervention>> _future;
  String _filtre = 'Toutes';

  @override
  void initState() {
    super.initState();
    _future = widget.api.getInterventions();
  }

  Color _couleurStatut(StatutIntervention s) {
    switch (s) {
      case StatutIntervention.enCours:
        return OneeColors.accent;
      case StatutIntervention.terminee:
        return OneeColors.success;
      case StatutIntervention.annulee:
        return OneeColors.danger;
      case StatutIntervention.planifiee:
        return OneeColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interventions')),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: ['Toutes', 'Planifiée', 'En cours', 'Terminée']
                  .map((f) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(f),
                          selected: _filtre == f,
                          selectedColor: OneeColors.primary.withOpacity(0.16),
                          onSelected: (_) => setState(() => _filtre = f),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Intervention>>(
              future: _future,
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final list = snap.data!
                    .where((i) =>
                        _filtre == 'Toutes' || i.statut.label == _filtre)
                    .toList();
                if (list.isEmpty) {
                  return const Center(
                      child: Text('Aucune intervention.',
                          style: TextStyle(color: OneeColors.textMuted)));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: list.length,
                  itemBuilder: (context, idx) {
                    final i = list[idx];
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        onTap: () => _ouvrirDetail(i),
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _couleurStatut(i.statut).withOpacity(0.14),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.build_outlined,
                              color: _couleurStatut(i.statut)),
                        ),
                        title: Text(i.type,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            Text('${i.clientNom} · ${i.ville}'),
                            Text(
                                DateFormat('d MMM yyyy', 'fr_FR')
                                    .format(i.datePrevue),
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: OneeColors.textMuted)),
                          ],
                        ),
                        trailing: _badge(i.statut),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(StatutIntervention s) {
    final c = _couleurStatut(s);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(s.label,
          style: TextStyle(
              color: c, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  void _ouvrirDetail(Intervention i) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(i.type,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(i.reference,
                style: const TextStyle(color: OneeColors.textMuted)),
            const Divider(height: 28),
            _ligne(Icons.person_outline, 'Client', i.clientNom),
            _ligne(Icons.location_on_outlined, 'Adresse',
                '${i.adresse}, ${i.ville}'),
            _ligne(Icons.event_outlined, 'Date prévue',
                DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(i.datePrevue)),
            _ligne(Icons.flag_outlined, 'Priorité', i.priorite),
            if (i.commentaire != null)
              _ligne(Icons.notes_outlined, 'Note', i.commentaire!),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('Itinéraire'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await widget.api
                          .changerStatut(i.id, StatutIntervention.terminee);
                      if (mounted) Navigator.pop(context);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Intervention marquée terminée.')),
                        );
                      }
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Clôturer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _ligne(IconData icon, String label, String valeur) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: OneeColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: OneeColors.textMuted)),
                Text(valeur,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
