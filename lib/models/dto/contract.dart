class Contract {
  String? id;
  late String reference;
  late String offer;
  String? type;
  String? client_id;

  Contract({
    required this.id,
    required this.reference,
    required this.offer,
    required this.type,
    this.client_id,
  });

  Contract.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reference = json['reference'];
    offer = json['offer'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reference'] = reference;
    data['offer'] = offer;
    data['type'] = type;
    data['client_id'] = client_id;
    return data;
  }
}
