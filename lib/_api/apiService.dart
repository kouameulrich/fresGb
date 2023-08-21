// ignore_for_file: file_names

import 'dart:convert';

import 'package:appfres/_api/dioClient.dart';
import 'package:appfres/_api/endpoints.dart';
import 'package:appfres/models/dto/contract.dart';
import 'package:appfres/models/dto/customer.dart';
import 'package:appfres/models/dto/payment.dto.dart';
import 'package:appfres/models/payment.dart';
import 'package:appfres/models/user.dart';

class ApiService {
  final DioClient _dioClient;
  ApiService(this._dioClient);

  // Future<User> getUserConnected(String username) async {
  //   String agentEndpoint = 'api/auth/signin/';
  //   final response = await _dioClient.post(agentEndpoint);
  //   return User.fromJson(response.data);
  // }

  Future<List<Contract>> getAllContracts() async {
    final response = await _dioClient.get(Endpoints.contracts);
    List<Contract> contrat =
        (response.data as List).map((e) => Contract.fromJson(e)).toList();
    return contrat;
  }

  Future<List<User>> getAllUsers() async {
    final response = await _dioClient.get(Endpoints.users);
    List<User> users =
        (response.data as List).map((e) => User.fromJson(e)).toList();
    return users;
  }

  Future<List<Payment>> getAllPayments() async {
    final response = await _dioClient.get(Endpoints.payments);
    List<Payment> payments =
        (response.data as List).map((e) => Payment.fromJson(e)).toList();
    return payments;
  }

  Future<void> sendPayment(List<Payment> payments, String agent) async {
    final paymentJson = convertPaymentToJsonDto(payments, agent)
        .map((e) => e.toJson())
        .toList();
    print(json.encode(paymentJson));
    await _dioClient.post(Endpoints.paiementFacture,
        data: json.encode(paymentJson));
  }

  List<Paymentdto> convertPaymentToJsonDto(
      List<Payment> payments, String matriculeagent) {
    List<Paymentdto> paymentdtos = [];
    for (var p in payments) {
      Paymentdto p1 = Paymentdto(
        id: p.id,
        agent: p.agent,
        contract: p.contract,
        amount: p.amount,
        paymentDate: p.paymentDate,
        status: p.status,
      );
      paymentdtos.add(p1);
    }
    return paymentdtos;
  }
}
