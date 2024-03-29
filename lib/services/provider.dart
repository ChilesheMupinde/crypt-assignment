import 'dart:convert';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
class CrowdfundingProvider extends ChangeNotifier{
  static const String ip = "192.168.17.245";
  static const String port = "7545";
  final String rpcUrl = "http://$ip:$port";
  final String WebsocketUrl = "ws://$ip:$port";
  final String privatekey =
      "0x7c63b394f16ea146d5b20ac72198d7569d3204e8077e67baa28de0c2c2828390";
  Web3Client? Ethclient;
  Client? httpClient;
  late Credentials _credentials;
  late DeployedContract _contract;
  late ContractAbi contractAbi;
  late EthereumAddress _contractAddress;


   void initState() async{
    // TODO: implement initState
    httpClient = Client();
    Ethclient = Web3Client(rpcUrl, httpClient!);
    SocketConnector(){
      return IOWebSocketChannel.connect(WebsocketUrl).cast<String>();
    }
    
    Future<void>getABI()async{
      String Abifile = await rootBundle
      .loadString("build/contracts/Crowdfunding.json");

      var JsonABI = jsonDecode(Abifile);
      contractAbi = jsonDecode(Abifile);

    _contractAddress = EthereumAddress.fromHex(JsonABI["networks"]["5777"]);

    }
    late EthPrivateKey _creds;
    Future<void>getCredentials()async{
      _creds = EthPrivateKey.fromHex(privatekey);
    }

    late DeployedContract _deployedcontract;
    late ContractFunction _createcampaign;
    late ContractFunction _donate;
    late ContractFunction _withdrawfunder;
    late ContractFunction _withdrawowner;

    Future<void>getdeployedContracts()async{
      _deployedcontract = DeployedContract(contractAbi, _contractAddress);
      _createcampaign = _deployedcontract.function("createcampaign");
      _withdrawowner = _deployedcontract.function("withdrawOwner");
      _donate = _deployedcontract.function("donate");
      _withdrawfunder = _deployedcontract.function("withdrawFunder");

    }


  }



}