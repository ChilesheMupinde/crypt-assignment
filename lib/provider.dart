import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
class CrowdfundingProvider extends ChangeNotifier{
  static const String ip = "";
  static const String port = "7545";
  final String rpcUrl = "http://$ip:$port";
  final String WebsocketUrl = "ws://$ip:$port";
  final String privatekey =
      "0x7c63b394f16ea146d5b20ac72198d7569d3204e8077e67baa28de0c2c2828390";
  late Web3Client web3client;
  late Credentials _credentials;
  late DeployedContract _contract;



}