import 'package:dapp2/utils/constants.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Client? httpclient;
  Web3Client? web3client;

  @override
  void initState() {
    // TODO: implement initState
    httpclient = Client();
    web3client = Web3Client(WebsocketUrl, httpclient!);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text("Thanks for being a contributor")
          ],
        ),
      ),

    );
  }
}
