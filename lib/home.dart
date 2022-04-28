import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ChatScreen.dart';
import 'MyProvider.dart';
class Home extends StatelessWidget {

  final _key=GlobalKey<FormState>();
  final texteditingcontroller=TextEditingController();
  void showMyDialog(BuildContext context){
    double HEIGTH=MediaQuery.of(context).size.height;
    double WIDTH=MediaQuery.of(context).size.width;

    AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.INFO,
      body: Container(
        height: HEIGTH*0.1,
        width: WIDTH*0.3,
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
             const Expanded(
                child:  FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    "Enter recipent name",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
               Expanded(
                 child: TextFormField(
                   controller: texteditingcontroller,
                   keyboardType: TextInputType.multiline,
                   minLines: 1,
                   maxLines: 10,
                   validator: (val)=>val!.isEmpty?"Enter a valid recipent":null,
                   onChanged: (val){
                     Provider.of<MyProvider>(context,listen: false).changeRecipent(val);
                   },
                 ),
               ),
            ],
          ),
        ),
      ),
      btnOkText: "Done",
      btnOkColor: Colors.blue,
      btnOkOnPress: () {
        if(texteditingcontroller.value.text.isNotEmpty){
          Navigator.push(context, MaterialPageRoute(
              builder: (context)=>ChatScreen()
          ));
        }
        
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    double HEIGTH=MediaQuery.of(context).size.height;
    double WIDTH=MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(
            Icons.people,
            size: 24,
          ),
        ),
        body: Container(
          width: WIDTH,
          height: HEIGTH,
          child: Center(
            child: FlatButton(
              color: Colors.blue,
              onPressed: (){
                Provider.of<MyProvider>(context,listen: false).clearChat();
              },
              child: const Text(
                "clear chat",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          splashColor: Colors.grey,
          backgroundColor: Colors.blue,
          onPressed: () {
            showMyDialog(context);
          },
          child: const Icon(
            Icons.chat_bubble,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}