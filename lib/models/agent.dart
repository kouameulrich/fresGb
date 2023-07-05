class Agent {
  String? matricule;
  String? nomUtilisateur;
  String? nom;
  String? prenom;

  @override
  String toString() {
    return 'Agent{matricule: $matricule, nomUtilisateur: $nomUtilisateur, nom: $nom, prenom: $prenom, telephone: $telephone, email: $email}';
  }

  String? telephone;
  String? email;

  Agent(
      {this.matricule,
      this.nomUtilisateur,
      this.nom,
      this.prenom,
      this.telephone,
      this.email});

  Agent.fromJson(Map<String, dynamic> json) {
    matricule = json['matricule'];
    nomUtilisateur = json['nomUtilisateur'];
    nom = json['nom'];
    prenom = json['prenom'];
    telephone = json['telephone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['matricule'] = matricule;
    data['nomUtilisateur'] = nomUtilisateur;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['telephone'] = telephone;
    data['email'] = email;
    return data;
  }
}
