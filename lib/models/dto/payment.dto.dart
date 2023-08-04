class Paymentdto {
  String? id;
  String? agent;
  double? amount;
  String? contract;
  String? paymentDate;

  Paymentdto({
    required this.id,
    required this.agent,
    required this.contract,
    required this.amount,
    required this.paymentDate,
  });

  @override
  String toString() {
    return 'Paymentdto{id: $id, agent: $agent, amount: $amount, contract: $contract, paymentDate: $paymentDate}';
  }

  Paymentdto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    agent = json['agent'];
    contract = json['contract'];
    amount = json['amount'];
    paymentDate = json['paymentDate'];
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
