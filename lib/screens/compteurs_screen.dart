import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../services/api_service.dart';
import '../models/compteur.dart';

class CompteursScreen extends StatefulWidget {
  const CompteursScreen({super.key, required this.api});
  final ApiService api;

  @override
  State<CompteursScreen> createState() => _CompteursScreenState();
}

class _CompteursScreenState extends State<CompteursScreen> {
  late Future<List<Compteur>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.api.getCompteurs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compteurs')),
      body: FutureBuilder<List<Compteur>>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snap.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, idx) {
              final c = list[idx];
              final estEau = c.type == 'Eau';
              final couleur = estEau ? const Color(0xFF2B8CC4) : OneeColors.accent;
              return Card(
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  onTap: () => _saisirReleve(c),
                  leading: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: couleur.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                        estEau ? Icons.water_drop_outlined : Icons.bolt,
                        color: couleur),
                  ),
                  title: Text(c.numeroSerie,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text(c.clientNom),
                      Text(
                          'Dernier index : ${c.dernierIndex.toStringAsFixed(0)} · ${DateFormat('d MMM', 'fr_FR').format(c.dernierReleve)}',
                          style: const TextStyle(
                              fontSize: 12, color: OneeColors.textMuted)),
                    ],
                  ),
                  trailing: const Icon(Icons.edit_note, color: OneeColors.primary),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _saisirReleve(Compteur c) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Relevé · ${c.numeroSerie}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dernier index : ${c.dernierIndex.toStringAsFixed(0)}',
                style: const TextStyle(color: OneeColors.textMuted)),
            const SizedBox(height: 14),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Nouvel index',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.speed),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              final val = double.tryParse(ctrl.text);
              if (val == null) return;
              await widget.api.envoyerReleve(Releve(
                  compteurId: c.id, nouvelIndex: val, date: DateTime.now()));
              if (mounted) Navigator.pop(context);
              if (mounted) {
                final conso = (val - c.dernierIndex).clamp(0, double.infinity);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Relevé enregistré · consommation ${conso.toStringAsFixed(0)}')),
                );
              }
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(110, 44)),
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }
}
