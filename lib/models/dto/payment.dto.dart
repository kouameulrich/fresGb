class Paymentdto {
  String? id;
  String? agent;
  double? amount;
  String? contract;
  String? paymentDate;
  String? status;

  Paymentdto({
    required this.id,
    required this.agent,
    required this.contract,
    required this.amount,
    required this.paymentDate,
    required this.status,
  });

  @override
  String toString() {
    return 'Payment{id: $id, agent: $agent, amount: $amount, contract: $contract, paymentDate: $paymentDate, status: $status}';
  }

  Paymentdto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    agent = json['agent'].toString();
    contract = json['contract'].toString();
    amount = json['amount'];
    paymentDate = json['paymentDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['agent'] = agent;
    data['contract'] = contract;
    data['amount'] = amount;
    data['paymentDate'] = paymentDate;
    data['status'] = status;
    return data;
  }
}
