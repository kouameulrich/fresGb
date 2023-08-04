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

  @override
  String toString() {
    return 'Payment{id: $id, agent: $agent, amount: $amount, contract: $contract, paymentDate: $paymentDate}';
  }

  Payment.fromJson(Map<String, dynamic> json) {
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
