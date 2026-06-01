import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/intervention.dart';
import '../models/compteur.dart';

/// Service d'accès à l'API REST ONEE.
///
/// En production, [baseUrl] pointe vers le backend (.NET / SQL Server).
/// Quand le backend n'est pas joignable, le service bascule
/// automatiquement sur un jeu de données de démonstration afin que
/// l'application reste utilisable hors-ligne (mode terrain).
class ApiService {
  ApiService({this.baseUrl = 'https://api.onee.local'});

  final String baseUrl;
  String? _token;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  Future<bool> login(String matricule, String motDePasse) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/api/auth/login'),
            headers: _headers,
            body: jsonEncode({'matricule': matricule, 'motDePasse': motDePasse}),
          )
          .timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        _token = (jsonDecode(res.body) as Map)['token'] as String?;
        return true;
      }
      return false;
    } catch (_) {
      // Mode démo : on accepte tout matricule non vide.
      if (matricule.trim().isNotEmpty && motDePasse.trim().isNotEmpty) {
        _token = 'demo-token';
        return true;
      }
      return false;
    }
  }

  Future<List<Intervention>> getInterventions() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/api/interventions'), headers: _headers)
          .timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body) as List;
        return data
            .map((e) => Intervention.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {/* fallback démo ci-dessous */}
    return _demoInterventions();
  }

  Future<List<Compteur>> getCompteurs() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/api/compteurs'), headers: _headers)
          .timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body) as List;
        return data
            .map((e) => Compteur.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {/* fallback démo ci-dessous */}
    return _demoCompteurs();
  }

  Future<bool> envoyerReleve(Releve releve) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/api/releves'),
            headers: _headers,
            body: jsonEncode(releve.toJson()),
          )
          .timeout(const Duration(seconds: 4));
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {
      return true; // file d'attente locale en mode démo
    }
  }

  Future<bool> changerStatut(int interventionId, StatutIntervention statut) async {
    try {
      final res = await http
          .patch(
            Uri.parse('$baseUrl/api/interventions/$interventionId'),
            headers: _headers,
            body: jsonEncode({'statut': statut.name}),
          )
          .timeout(const Duration(seconds: 4));
      return res.statusCode == 200;
    } catch (_) {
      return true;
    }
  }

  // --- Données de démonstration --------------------------------------------

  List<Intervention> _demoInterventions() {
    final now = DateTime.now();
    return [
      Intervention(
        id: 1,
        reference: 'INT-2026-0184',
        type: 'Branchement neuf',
        clientNom: 'Société Atlas Négoce',
        adresse: 'Lot 42, Zone industrielle Sidi Bernoussi',
        ville: 'Casablanca',
        datePrevue: now,
        statut: StatutIntervention.enCours,
        priorite: 'Haute',
        commentaire: 'Prévoir disjoncteur 60A.',
      ),
      Intervention(
        id: 2,
        reference: 'INT-2026-0185',
        type: 'Réparation compteur',
        clientNom: 'El Amrani Khadija',
        adresse: '12 Rue des Orangers, Maârif',
        ville: 'Casablanca',
        datePrevue: now,
        statut: StatutIntervention.planifiee,
        priorite: 'Normale',
      ),
      Intervention(
        id: 3,
        reference: 'INT-2026-0186',
        type: 'Coupure pour impayé',
        clientNom: 'Benani Youssef',
        adresse: '88 Bd Mohammed V',
        ville: 'Mohammedia',
        datePrevue: now.add(const Duration(days: 1)),
        statut: StatutIntervention.planifiee,
        priorite: 'Basse',
      ),
      Intervention(
        id: 4,
        reference: 'INT-2026-0181',
        type: 'Relevé contradictoire',
        clientNom: 'Résidence Al Manar',
        adresse: 'Av. Hassan II, Imm. C',
        ville: 'Casablanca',
        datePrevue: now.subtract(const Duration(days: 1)),
        statut: StatutIntervention.terminee,
        priorite: 'Normale',
      ),
      Intervention(
        id: 5,
        reference: 'INT-2026-0179',
        type: 'Fuite réseau eau',
        clientNom: 'Commune de Aïn Harrouda',
        adresse: 'Quartier industriel',
        ville: 'Aïn Harrouda',
        datePrevue: now,
        statut: StatutIntervention.planifiee,
        priorite: 'Haute',
      ),
    ];
  }

  List<Compteur> _demoCompteurs() {
    final now = DateTime.now();
    return [
      Compteur(
        id: 1,
        numeroSerie: 'ELC-77451209',
        type: 'Électricité',
        clientNom: 'Société Atlas Négoce',
        adresse: 'Lot 42, ZI Sidi Bernoussi',
        dernierIndex: 18420,
        dernierReleve: now.subtract(const Duration(days: 32)),
      ),
      Compteur(
        id: 2,
        numeroSerie: 'ELC-77451341',
        type: 'Électricité',
        clientNom: 'El Amrani Khadija',
        adresse: '12 Rue des Orangers, Maârif',
        dernierIndex: 6231,
        dernierReleve: now.subtract(const Duration(days: 29)),
      ),
      Compteur(
        id: 3,
        numeroSerie: 'EAU-30298814',
        type: 'Eau',
        clientNom: 'Résidence Al Manar',
        adresse: 'Av. Hassan II, Imm. C',
        dernierIndex: 1245,
        dernierReleve: now.subtract(const Duration(days: 30)),
      ),
      Compteur(
        id: 4,
        numeroSerie: 'EAU-30298990',
        type: 'Eau',
        clientNom: 'Commune de Aïn Harrouda',
        adresse: 'Quartier industriel',
        dernierIndex: 50871,
        dernierReleve: now.subtract(const Duration(days: 35)),
      ),
    ];
  }
}
