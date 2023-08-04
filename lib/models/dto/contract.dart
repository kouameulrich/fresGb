class Contract {
  late String reference;
  late String offer;
  String? type;
  String? client_id;

  Contract({
    required this.reference,
    required this.offer,
    required this.type,
    this.client_id,
  });

  Contract.fromJson(Map<String, dynamic> json) {
    reference = json['reference'];
    offer = json['offer'];
    type = json['type'];
  }

  @override
  String toString() {
    return 'Contract{reference: $reference, offer: $offer, type: $type, client_id: $client_id}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reference'] = reference;
    data['offer'] = offer;
    data['type'] = type;
    data['client_id'] = client_id;
    return data;
  }
}
