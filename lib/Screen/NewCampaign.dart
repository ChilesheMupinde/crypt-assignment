import 'dart:io';

import 'package:dapp2/services/backend.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:web3dart/web3dart.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  Web3Client? Ethclient;
  Client? httpClient;

  @override
  void initState() {
    // TODO: implement initState
    httpClient = Client();
    Ethclient = Web3Client(url, httpClient!);
  }
 
  @override
  


  Widget build(BuildContext context) {
    final ImagePicker _picker = ImagePicker();
   XFile? _image;
  final now = DateTime.now();
  DateTime tommorrow = DateTime(now.year, now.month, now.day + 1);
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController Description = TextEditingController();
  final TextEditingController Amount = TextEditingController();
  final TextEditingController Titlecontroller = TextEditingController();

    Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tommorrow,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != tommorrow) {
      setState(() {
        tommorrow = picked;
      });
    }
  }

    Future getCametaImage() async {
    _image = await _picker.pickImage(source: ImageSource.camera);
    if (_image != null) {
      setState(() {
        _image;
      });
    }
  }

  Future getGalleryImage() async {
    _image = await _picker.pickImage(source: ImageSource.gallery);
    if (_image != null) {
      setState(() {
        _image;
      });
    }
  }
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          child:Container(
            padding:const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        actionsPadding:
                            const EdgeInsets.symmetric(vertical: 30),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          FloatingActionButton(
                            onPressed: () {
                              getCametaImage();
                              Navigator.pop(context);
                              // context.pop();
                            },
                            child: const Icon(Icons.camera_alt),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              getGalleryImage();
                              Navigator.pop(context);
                              // context.pop();
                            },
                            child: const Icon(Icons.photo_library),
                          )
                        ],
                      ),
                    ),

                    child: CircleAvatar(
                        // radius: 35,
                        minRadius: 30,
                        maxRadius: 36,
                        // backgroundColor: Colors.transparent,
                        backgroundImage: _image != null
                            ? FileImage(File(_image!.path))
                            : null,
                        child: _image == null
                            ? const Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.blue,
                                size: 30,
                              )
                            : null),
                  ),
                const Row(
                  children: [
                    Text("Name"),
                    SizedBox(width: 160,),
                    Text("Title")
                  ],
            
                ),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        controller: namecontroller,
                        decoration: const InputDecoration(
                          label: Text("Name"),
                          border: OutlineInputBorder(),
            
                        ),
                      ),
                    ),
            
                   const SizedBox(width: 50,),
                    SizedBox(
                      width: 150,
                      child:TextFormField(
                        controller: Titlecontroller,
                        decoration: const InputDecoration(
                          label: Text("Title"),
                          border: OutlineInputBorder(),
            
                        ),
                      ),
                    ),
        
                  ],
                ),
                const SizedBox(height: 20,),
                const Text("Description"),
                const SizedBox(height: 20,),
                TextFormField(
                  maxLines: 5,
                  controller: Description,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
        
                  ),
                ),
                const SizedBox(height: 20,),
          const Text("Target Amount"),
          const SizedBox(height: 20,),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: Amount,
            decoration: const  InputDecoration(
              border: OutlineInputBorder(),
            ),),
          const SizedBox(height: 20,),
          const Text("Deadline"),
          const SizedBox(height: 10,),
                         ElevatedButton.icon(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.calendar_month, color: Colors.blue),
                  label: Text(DateFormat('dd/MM/yyyy').format(tommorrow)),
                  style: ElevatedButton.styleFrom(
                      onPrimary: Colors.black, primary: Colors.white),
                ),
                const SizedBox(height: 20,),
                ElevatedButton(onPressed: (){
                  Createcampaign(
                    Ethclient!, Titlecontroller.text, Description.text,int.parse(Amount.text) , tommorrow);
                }, child: Text("Add new Campaign"))
        
              ],
            ),
          )
        ),
      )    );
  }
}
