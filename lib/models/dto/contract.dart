class Contract {
  late String id;
  late String clientName;
  late String offer;

  Contract({
    required this.id,
    required this.clientName,
    required this.offer,
  });

  Contract.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientName = json['clientName'];
    offer = json['offer'];
  }

  @override
  String toString() {
    return 'Contract{id: $id, offer: $offer, client_id: $clientName}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['clientName'] = clientName;
    data['offer'] = offer;
    return data;
  }
}
