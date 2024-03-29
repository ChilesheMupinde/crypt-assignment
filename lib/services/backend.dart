import 'dart:io';
import 'package:dapp4/models/campaign_model.dart';
import 'package:dapp4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

// class Campaigncontroller extends ChangeNotifier{
//   List<Campaign> campaigns = [];
  int? num_of_campaigns;
  Web3Client? EthClient;
  EthPrivateKey? credentials;

  var credentias = EthPrivateKey.
  fromHex("0x26437b9ee64978efc59124cd86410d7f871cf3be2fa521874e6705472e3c27ca");
  var address = credentias.address;
  EtherAmount balance = EthClient!.getBalance(address) as EtherAmount;

  // late ContractFunction createCampaign;
  // late ContractFunction _campaigns;
  Future<DeployedContract> loadcontract()async{
    String abi = await rootBundle.loadString('assets/abi.json');
    String ContractAddress = ContractAddress1;
    final contract = DeployedContract(ContractAbi.fromJson(abi, 'Crowdfunding2'),
        EthereumAddress.fromHex(ContractAddress));
    return contract;
  }

  Future<String> callFunction(String funcname, List<dynamic> args,
      Web3Client EthClient, String privateKey) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
    DeployedContract contract = await loadcontract();
    final ethFunction = contract.function(funcname);


    final result = await EthClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        gasPrice: EtherAmount.fromInt(EtherUnit.gwei, 3),
        maxGas: 23000,
        function: ethFunction,
        parameters: args,

        // maxFeePerGas: EtherAmount.fromInt(EtherUnit.ether, 788177330)
      ),
        chainId: 1337,
        fetchChainIdFromNetworkId: false


    );
    return result;
  }

  // getCampaigns() async {
  //   DeployedContract contract = await loadcontract();
  //   _campaigns = contract.function("Campaign");
  //   List CampaignList = await EthClient!
  //       .call(contract: contract, function: _campaigns, params: []);
  //   BigInt totalNotes = CampaignList[0];
  //    num_of_campaigns= totalNotes.toInt();
  //    campaigns.clear();
  //   for (int i = 0; i < num_of_campaigns!; i++) {
  //     var temp = await EthClient!.call(
  //         contract: contract, function: _campaigns, params: [BigInt.from(i)]);
  //     if (temp[1] != "")
  //       campaigns.add(
  //         Campaign(
  //           User: temp[0],
  //           title: temp[1],
  //           Description: temp[2],
  //           targetAmount:  temp[3],
  //           deadline:  temp[4],
  //
  //         ),
  //       );
  //   }
  //
  // }
  //
  //
  // addContract(Campaign campaign)async{
  //   DeployedContract contract = await loadcontract();
  //   createCampaign = contract.function("createcampaign");
  //   await EthClient!.sendTransaction(
  //     credentials!,
  //     Transaction.callContract(
  //       contract: contract,
  //       function: createCampaign,
  //       parameters: [
  //         campaign.User,
  //         campaign.title,
  //         campaign.Description,
  //         campaign.targetAmount,
  //         BigInt.from(campaign.deadline.millisecondsSinceEpoch)
  //       ],
  //     ),
  //   );
  //   await getCampaigns();
  // }
//Creating a new campaign


  Future<String> Createcampaign( EthereumAddress address,String title, String Description, int targetAmount
      ,int deadline, Web3Client User)async{
    var response = await callFunction('createCampaign',
        [ address,title,Description,BigInt.from(targetAmount),BigInt.from(deadline)], User, privatekey);
    print("Campaign created succesfully");
    return response;
  }

//Function for donating
  Future<String> donate(int id, Web3Client user)async{
    var response = await callFunction('donate', [BigInt.from(id)], user, funder_privatekey);
    print("Campaign created succesfully");
    return response;

  }

  Future<String> withdrawowner(int id, Web3Client user)async{
    var response = await callFunction('withdrawOwner', [BigInt.from(id)], user, privatekey);
    print("Money Withdrawn succesfully");
    return response;

  }

  Future<String> withdrawfunder(int id, Web3Client user)async{
    var response = await callFunction('withdrawFunder', [BigInt.from(id)], user, funder_privatekey);
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
// }
