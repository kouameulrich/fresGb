class EncaissementDto {
  String? nomClient;
  String? prenomClient;
  String? sexeClient;
  String? numeroCompteur;
  double? montantClient;
  String? telephoneClient;
  String? dateEncaissement;
  String? matriculeAgent;

  @override
  String toString() {
    return 'EncaissementDto{nomClient: $nomClient, prenomClient: $prenomClient, sexeClient: $sexeClient, numeroCompteur: $numeroCompteur, montantClient: $montantClient, telephoneClient: $telephoneClient, dateEncaissement: $dateEncaissement, matriculeAgent: $matriculeAgent}';
  }

  EncaissementDto({
    this.nomClient,
    this.prenomClient,
    this.sexeClient,
    this.numeroCompteur,
    this.montantClient,
    this.telephoneClient,
    this.dateEncaissement,
    this.matriculeAgent,
  });

  EncaissementDto.fromJson(Map<String, dynamic> json) {
    nomClient = json['nomClient'];
    prenomClient = json['prenomClient'];
    sexeClient = json['sexeClient'];
    numeroCompteur = json['numeroCompteur'];
    montantClient = json['montantClient'];
    telephoneClient = json['telephoneClient'];
    dateEncaissement = json['dateEncaissement'];
    matriculeAgent = json['matriculeAgent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nomClient'] = nomClient;
    data['prenomClient'] = prenomClient;
    data['sexeClient'] = sexeClient;
    data['numeroCompteur'] = numeroCompteur;
    data['montantClient'] = montantClient;
    data['telephoneClient'] = telephoneClient;
    data['dateEncaissement'] = dateEncaissement;
    data['matriculeAgent'] = matriculeAgent;
    return data;
  }
}
