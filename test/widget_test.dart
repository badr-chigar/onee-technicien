import 'package:flutter_test/flutter_test.dart';
import 'package:onee_technicien/models/intervention.dart';
import 'package:onee_technicien/models/compteur.dart';

void main() {
  test('Intervention.fromJson mappe correctement le statut', () {
    final i = Intervention.fromJson({
      'id': 1,
      'reference': 'INT-2026-0001',
      'type': 'Branchement',
      'clientNom': 'Test',
      'adresse': 'Rue X',
      'ville': 'Casablanca',
      'datePrevue': '2026-06-01T09:00:00',
      'statut': 'EN_COURS',
      'priorite': 'Haute',
    });
    expect(i.statut, StatutIntervention.enCours);
    expect(i.statut.label, 'En cours');
    expect(i.ville, 'Casablanca');
  });

  test('Statut inconnu retombe sur planifiée', () {
    expect(StatutLabel.fromString(null), StatutIntervention.planifiee);
    expect(StatutLabel.fromString('???'), StatutIntervention.planifiee);
  });

  test('Releve.toJson sérialise les champs attendus', () {
    final r = Releve(
      compteurId: 3,
      nouvelIndex: 1280,
      date: DateTime.parse('2026-06-01T10:00:00'),
    );
    final json = r.toJson();
    expect(json['compteurId'], 3);
    expect(json['nouvelIndex'], 1280);
    expect(json['date'], '2026-06-01T10:00:00.000');
  });

  test('Compteur.fromJson lit l\'index', () {
    final c = Compteur.fromJson({
      'id': 2,
      'numeroSerie': 'ELC-1',
      'type': 'Électricité',
      'clientNom': 'Client',
      'adresse': 'Rue Y',
      'dernierIndex': 4200,
      'dernierReleve': '2026-05-01T00:00:00',
    });
    expect(c.dernierIndex, 4200);
    expect(c.type, 'Électricité');
  });
}
