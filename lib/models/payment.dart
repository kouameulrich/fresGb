class Payment {
  String? id;
  String? agent;
  double? amount;
  String? contract;
  String? paymentDate;

  Payment({
    required this.id,
    required this.agent,
    required this.contract,
    required this.amount,
    required this.paymentDate,
  });

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    agent = json['agent'].toString();
    contract = json['contract'].toString();
    amount = double.tryParse(json['amount'].toString());
    paymentDate = json['paymentDate'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['agent'] = agent;
    data['contract'] = contract;
    data['amount'] = amount;
    data['paymentDate'] = paymentDate;
    return data;
  }
}
