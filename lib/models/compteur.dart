class Compteur {
  final int id;
  final String numeroSerie;
  final String type; // Électricité, Eau
  final String clientNom;
  final String adresse;
  final double dernierIndex;
  final DateTime dernierReleve;

  Compteur({
    required this.id,
    required this.numeroSerie,
    required this.type,
    required this.clientNom,
    required this.adresse,
    required this.dernierIndex,
    required this.dernierReleve,
  });

  factory Compteur.fromJson(Map<String, dynamic> json) {
    return Compteur(
      id: json['id'] as int,
      numeroSerie: json['numeroSerie'] as String? ?? '',
      type: json['type'] as String? ?? 'Électricité',
      clientNom: json['clientNom'] as String? ?? '',
      adresse: json['adresse'] as String? ?? '',
      dernierIndex: (json['dernierIndex'] as num?)?.toDouble() ?? 0,
      dernierReleve: DateTime.tryParse(json['dernierReleve'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

/// Relevé saisi par le technicien sur le terrain.
class Releve {
  final int compteurId;
  final double nouvelIndex;
  final DateTime date;

  Releve({
    required this.compteurId,
    required this.nouvelIndex,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'compteurId': compteurId,
        'nouvelIndex': nouvelIndex,
        'date': date.toIso8601String(),
      };
}
