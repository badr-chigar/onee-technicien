import 'package:flutter/material.dart';
import '../main.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.valeur,
    required this.libelle,
    required this.icone,
    required this.couleur,
  });

  final String valeur;
  final String libelle;
  final IconData icone;
  final Color couleur;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: couleur.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icone, color: couleur, size: 22),
            ),
            const SizedBox(height: 12),
            Text(valeur,
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: OneeColors.textDark)),
            Text(libelle,
                style: const TextStyle(
                    fontSize: 13, color: OneeColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
