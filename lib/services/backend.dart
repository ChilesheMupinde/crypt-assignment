import 'dart:io';
import 'package:dapp2/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadcontract()async{
  String abi = await rootBundle.loadString('assets/abi.json');
  String ContractAddress = ContractAddress1;
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Crowdfunding'), 
  EthereumAddress.fromHex(ContractAddress));
  return contract;
}

Future<String> callfunction(String funcname, List<dynamic> args,Web3Client ethclient, String privatekey)async{
  EthPrivateKey credentials = EthPrivateKey.fromHex(privatekey);
  DeployedContract contract = await loadcontract();
  final ethfunction = contract.function(funcname);
  final result = await ethclient.sendTransaction(credentials, Transaction.callContract(contract: contract, 
  function: ethfunction, parameters: args));

  return result;

}

Future<String> Createcampaign(Web3Client user, String title, String Description, int targetAmount
, DateTime deadline)async{
var response = await callfunction('createcampaign', [user,title,Description,BigInt.from(targetAmount),deadline], user, privatekey);
print("Campaign created succesfully");
return response;

}

Future<String> donate(int id, Web3Client user)async{
var response = await callfunction('donate', [BigInt.from(id)], user, funder_privatekey);
print("Campaign created succesfully");
return response;

}

Future<String> withdrawowner(int id, Web3Client user)async{
var response = await callfunction('withdrawOwner', [BigInt.from(id)], user, privatekey);
print("Money Withdrawn succesfully");
return response;

}

Future<String> withdrawfunder(int id, Web3Client user)async{
var response = await callfunction('withdrawFunder', [BigInt.from(id)], user, funder_privatekey);
print("User withdrawn succesfully");
return response;

}

Future<List<dynamic>>Ask(String funcname, List<dynamic> args, Web3Client ethclient)async{
  DeployedContract contract = await loadcontract();
  final ethfunction = contract.function(funcname);
   final result = await ethclient.call(contract: contract, 
  function: ethfunction, params: args);
  return result;
}