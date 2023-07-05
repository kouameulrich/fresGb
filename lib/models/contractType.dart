class ContractType {
  String? id;
  String? name;

  ContractType({
    required this.id,
    required this.name,
  });

  factory ContractType.fromJson(Map<String, dynamic> json) {
    return ContractType(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
