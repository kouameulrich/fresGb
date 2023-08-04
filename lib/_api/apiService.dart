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

  Future<User> getUserConnected(String trim) async {
    String agentEndpoint = 'http://192.168.1.8:8080/api/auth/signin';
    final response = await _dioClient.post(agentEndpoint);
    return User.fromJson(response.data);
  }

  Future<List<Contract>> getAllContracts() async {
    String contractEndpoints = '/api/public/allContracts';
    final response = await _dioClient.get(contractEndpoints);
    List<dynamic> data = response.data;
    List<Contract> contrat = data.map((e) => Contract.fromJson(e)).toList();
    return contrat;
  }

  Future<List<Customer>> getAllClients() async {
    String clientsEndpoints = '/api/public/allClient';
    final response = await _dioClient.get(clientsEndpoints);
    List<dynamic> data = response.data;
    List<Customer> customer = data.map((e) => Customer.fromJson(e)).toList();
    return customer;
  }

  Future<List<User>> getAllUsers() async {
    String UserEndpoints = '/api/public/allUsers';
    final response = await _dioClient.get(UserEndpoints);
    List<dynamic> data = response.data;
    List<User> users = data.map((e) => User.fromJson(e)).toList();
    return users;
  }

  Future<List<Payment>> getAllPayments() async {
    String paymentFactureEndpoints = '/api/public/allPayments';
    final response = await _dioClient.get(paymentFactureEndpoints);
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
      );
      paymentdtos.add(p1);
    }
    return paymentdtos;
  }
}
