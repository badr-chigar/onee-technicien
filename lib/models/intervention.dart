enum StatutIntervention { planifiee, enCours, terminee, annulee }

extension StatutLabel on StatutIntervention {
  String get label {
    switch (this) {
      case StatutIntervention.planifiee:
        return 'Planifiée';
      case StatutIntervention.enCours:
        return 'En cours';
      case StatutIntervention.terminee:
        return 'Terminée';
      case StatutIntervention.annulee:
        return 'Annulée';
    }
  }

  static StatutIntervention fromString(String? s) {
    switch (s) {
      case 'EN_COURS':
        return StatutIntervention.enCours;
      case 'TERMINEE':
        return StatutIntervention.terminee;
      case 'ANNULEE':
        return StatutIntervention.annulee;
      default:
        return StatutIntervention.planifiee;
    }
  }
}

class Intervention {
  final int id;
  final String reference;
  final String type; // Branchement, Réparation, Relevé, Coupure...
  final String clientNom;
  final String adresse;
  final String ville;
  final DateTime datePrevue;
  final StatutIntervention statut;
  final String priorite; // Haute, Normale, Basse
  final String? commentaire;

  Intervention({
    required this.id,
    required this.reference,
    required this.type,
    required this.clientNom,
    required this.adresse,
    required this.ville,
    required this.datePrevue,
    required this.statut,
    required this.priorite,
    this.commentaire,
  });

  factory Intervention.fromJson(Map<String, dynamic> json) {
    return Intervention(
      id: json['id'] as int,
      reference: json['reference'] as String? ?? '',
      type: json['type'] as String? ?? '',
      clientNom: json['clientNom'] as String? ?? '',
      adresse: json['adresse'] as String? ?? '',
      ville: json['ville'] as String? ?? '',
      datePrevue: DateTime.tryParse(json['datePrevue'] as String? ?? '') ??
          DateTime.now(),
      statut: StatutLabel.fromString(json['statut'] as String?),
      priorite: json['priorite'] as String? ?? 'Normale',
      commentaire: json['commentaire'] as String?,
    );
  }
}
