// ignore_for_file: non_constant_identifier_names

import 'package:appfres/db/repository.dart';
import 'package:appfres/models/dto/contract.dart';
import 'package:appfres/models/dto/customer.dart';
import 'package:appfres/models/payment.dart';
import 'package:appfres/models/user.dart';

class LocalService {
  final Repository _repository;

  LocalService(this._repository);

  // Encaissement

  //Save Encaissement
  Future<int> SavePayment(Payment payment) async {
    return await _repository.insertData('payment', payment.toJson());
  }

  //Read All Encaissement
  Future<List<Payment>> readAllPayment() async {
    List<Payment> payments = [];
    List<Map<String, dynamic>> list = await _repository.readData('payment');
    for (var payment in list) {
      payments.add(Payment.fromJson(payment));
    }
    return payments;
  }

  //Edit Encaissement
  UpdatePayment(Payment payment) async {
    return await _repository.updateData('payment', payment.toJson());
  }

  // delete Encaissement
  deletePayment(paymentId) async {
    return await _repository.deleteDataById('payment', paymentId);
  }

  Future<List<User>> login() async {
    List<User> users = [];
    List<Map<String, dynamic>> list = await _repository.readData('users');
    for (var user in list) {
      users.add(User.fromJson(user));
    }
    return users;
  }

  //Save client
  Future<int> SaveCustomer(Customer customer) async {
    return await _repository.insertData('client', customer.toJson());
  }

  Future<List<Customer>> readAllClient() async {
    List<Customer> clients = [];
    List<Map<String, dynamic>> list = await _repository.readData('client');
    for (var client in list) {
      clients.add(Customer.fromJson(client));
    }
    return clients;
  }

  Future<List<Contract>> getContractsPerClient(clientId) async {
    var sql = "SELECT * FROM contract WHERE client_id = $clientId";
    List<Contract> contracts = [];
    List<Map<String, dynamic>> list = await _repository.rawSelect(sql);
    for (var contract in list) {
      contracts.add(Contract.fromJson(contract));
    }
    return contracts;
  }

  //Save contract
  Future<int> SaveContract(Contract contract) async {
    return await _repository.insertData('contract', contract.toJson());
  }

  Future<List<Contract>> readAllContract() async {
    List<Contract> contracts = [];
    List<Map<String, dynamic>> list = await _repository.readData('contract');
    for (var contract in list) {
      contracts.add(Contract.fromJson(contract));
    }
    return contracts;
  }

  //Save user
  Future<int> SaveUser(User user) async {
    return await _repository.insertData('user', user.toJson());
  }
}
