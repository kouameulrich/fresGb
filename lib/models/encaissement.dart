// ignore_for_file: override_on_non_overriding_member

class Encaissement {
  int? id;
  String? nomClient;
  String? prenomClient;
  String? sexeClient;
  String? numeroCompteur;
  double? montantClient;
  String? telephoneClient; // code du Secteur
  String? dateEncaissement; // type de TypeActiviteCommerciale
  String? matriculeAgent;

  @override
  String toString() {
    return 'Encaissement{id: $id, nomClient: $nomClient, prenomClient: $prenomClient, sexeClient: $sexeClient, numeroCompteur: $numeroCompteur, montantClient: $montantClient, telephoneClient: $telephoneClient, dateEncaissement: $dateEncaissement, matriculeAgent: $matriculeAgent}';
  }

  Encaissement({
    this.id,
    this.nomClient,
    this.prenomClient,
    this.sexeClient,
    this.numeroCompteur,
    this.montantClient,
    this.telephoneClient,
    this.dateEncaissement,
    this.matriculeAgent,
  });

  Encaissement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    data['id'] = id;
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

  @override
  int compareTo(other) {
    return DateTime.parse(convertFormatDate(other.dateEncaissement!))
        .compareTo(DateTime.parse(convertFormatDate(dateEncaissement!)));
  }

  convertFormatDate(String date) {
    return '${date.substring(6, 10)}-${date.substring(3, 5)}-${date.substring(0, 2)} ${date.substring(11)}';
  }
}
