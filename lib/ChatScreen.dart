
import 'dart:ffi';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ganeshchatap/ChatModel.dart';
import 'package:ganeshchatap/MyProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
class ChatScreen extends StatefulWidget {

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chattextfield=TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final _TEXTTAG="TEXT";
  final _IMAGTAG="IMAGE";
  final _IMAGTAGWITHTEXT="IMAGEWITHTEXT";
  late int editmessageindex;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    Provider.of<MyProvider>(context,listen: false).changeMessageType("SENT");
    scrollDown(Provider.of<MyProvider>(context,listen: false).controller);
  }
  
  @override
  Widget build(BuildContext context) {
    double HEIGTH=MediaQuery.of(context).size.height;
    double WIDTH=MediaQuery.of(context).size.width;
    
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue,
          leading: const Icon(
            Icons.person,
            color: Colors.white,
            size: 24,
          ),
          title: Consumer<MyProvider>(
            builder: (context,myprovider,child){
              return GestureDetector(
                onTap: (){
                    // controller.animateTo(
                    //   controller.position.maxScrollExtent,
                    //   duration: Duration(seconds: myprovider.chats.length-1*10.toInt()),
                    //   curve: Curves.linear,
                    // );
                  myprovider.startAutoPlay(getTextEditingController());
                },
                child: Text(
                  Provider.of<MyProvider>(context,listen: false).recipent,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              );
            },
          )
        ),
        body: Column(
          children: [
            Consumer<MyProvider>(
              builder: (context,myprovider,child){
                return Expanded(
                  child: Container(
                    color: Colors.white,
                    width: WIDTH,
                    height: HEIGTH*0.8,
                    padding: const EdgeInsets.all(5),
                    child: ListView.builder(
                      itemCount: myprovider.chats.length, 
                        controller: myprovider.controller,
                        itemBuilder: (context,index){
                          return myprovider.chats[index].messagetype=="SENT"?Align(
                            alignment: Alignment.centerRight,
                            child: myprovider.chats[index].tag==_TEXTTAG?GestureDetector(
                              onLongPress: (){
                                editmessageindex=index;
                                showEdit(context, index, myprovider, chattextfield);
                              },
                              child: Container(
                                margin: EdgeInsets.all(WIDTH*0.015),
                                padding: EdgeInsets.all(WIDTH*0.03),
                                decoration: const BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                child: Text(
                                    myprovider.chats[index].message!,
                                  style:  TextStyle(
                                    color: Colors.white,
                                    fontSize: WIDTH*0.05,
                                    overflow: TextOverflow.visible
                                  ),
                                ),
                              ),
                            ):SizedBox(
                              height: HEIGTH*0.4,
                              width: WIDTH*0.5,
                              child: Column(
                                crossAxisAlignment: myprovider.chats[index].messagetype=="SENT"?CrossAxisAlignment.end:CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex:5,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(WIDTH*0.05)),
                                      ),
                                      elevation: 5,
                                      shadowColor: Colors.black54,
                                      child: SizedBox(
                                        height: HEIGTH*0.4,
                                        width: WIDTH*0.5,
                                        child: Hero(
                                          tag: index,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(WIDTH*0.05)),
                                            child: Image.file(
                                              File(myprovider.chats[index].imagepath!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  myprovider.chats[index].message!.isNotEmpty?Expanded(
                                    flex:1,
                                    child: GestureDetector(
                                      onLongPress: (){
                                        editmessageindex=index;
                                        showEdit(context, index, myprovider, chattextfield);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(WIDTH*0.015),
                                        padding: EdgeInsets.all(WIDTH*0.03),
                                        decoration: const BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(Radius.circular(15))
                                        ),
                                        child: Text(
                                          myprovider.chats[index].message!,
                                          textAlign: TextAlign.right,
                                          style:  TextStyle(
                                              color: Colors.white,
                                              fontSize: WIDTH*0.05,
                                              overflow: TextOverflow.visible
                                          ),
                                        ),
                                      ),
                                    ),
                                  ):Expanded(
                                      child: Container()
                                  )
                                ],
                              ),
                            ),
                          ):Align(
                            alignment: Alignment.centerLeft,
                            child: myprovider.chats[index].tag==_TEXTTAG?GestureDetector(
                              onLongPress: (){
                                editmessageindex=index;
                                showEdit(context, index, myprovider, chattextfield);
                              },
                              child: Container(
                                margin: EdgeInsets.all(WIDTH*0.015),
                                padding: EdgeInsets.all(WIDTH*0.03),
                                decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                child: Text(
                                  myprovider.chats[index].message!,
                                  style:  TextStyle(
                                      color: Colors.white,
                                      fontSize: WIDTH*0.05,
                                      overflow: TextOverflow.visible
                                  ),
                                ),
                              ),
                            ):SizedBox(
                              height: HEIGTH*0.4,
                              width: WIDTH*0.5,
                              child: Column(
                                crossAxisAlignment: myprovider.chats[index].messagetype=="RECEIVED"?CrossAxisAlignment.start:CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    flex:5,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(WIDTH*0.05)),
                                      ),
                                      elevation: 5,
                                      shadowColor: Colors.black54,
                                      child: SizedBox(
                                        height: HEIGTH*0.4,
                                        width: WIDTH*0.5,
                                        child: Hero(
                                          tag: index,
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(WIDTH*0.05)),
                                              child: Image.file(
                                              File(myprovider.chats[index].imagepath!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  myprovider.chats[index].message!.isNotEmpty?Expanded(
                                    flex:1,
                                    child: GestureDetector(
                                      onLongPress: (){
                                        editmessageindex=index;
                                        showEdit(context, index, myprovider, chattextfield);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(WIDTH*0.015),
                                        padding: EdgeInsets.all(WIDTH*0.03),
                                        decoration: const BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.all(Radius.circular(15))
                                        ),
                                        child: Text(
                                          myprovider.chats[index].message!,
                                          textAlign: TextAlign.right,
                                          style:  TextStyle(
                                              color: Colors.white,
                                              fontSize: WIDTH*0.05,
                                              overflow: TextOverflow.visible
                                          ),
                                        ),
                                      ),
                                    ),
                                  ):Expanded(
                                      child: Container()
                                  )
                                ],
                              ),
                            ),
                          );
                      }
                    ),
                  ),
                );
                
              },
            ),
            Consumer<MyProvider>(
              builder: (context,myprovider,child){
                return Container(
                  margin: const EdgeInsets.all(3),
                  height: HEIGTH*0.08,
                  width: WIDTH,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex:1,
                        child: SizedBox(
                          child: IconButton(
                           icon: const Icon(
                             Icons.face,
                             color: Colors.black54,
                           ), 
                            onPressed: (){
                             myprovider.changeWrittingStatus(true);
                            },
                          )
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          height: HEIGTH*0.08,
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 10,
                            cursorColor: myprovider.isAutoplay?Colors.white:Colors.grey,
                            decoration:const InputDecoration(
                              fillColor: Colors.grey,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              )
                            ),
                            controller: chattextfield,
                            onTap: (){
                              myprovider.changeWrittingStatus(false);
                            },
                            onChanged: (val){
                              myprovider.changeWrittingStatus(false);
                            },
                            showCursor: true,
                          ),
                         ),
                       ), 
                      !myprovider.editMessageFlag?Expanded(
                        flex:1,
                        child: GestureDetector(
                          onTap: ()async{
                            if(chattextfield.value.text.isNotEmpty){
                              await myprovider.addChat(chattextfield.value.text,_TEXTTAG,null);
                              scrollDown(myprovider.controller);
                              chattextfield.clear();
                            }
                          },
                          onLongPress: (){
                            print("on long press");
                            if(myprovider.messagetype=="SENT"){
                              myprovider.changeMessageType("RECEIVED");
                            }else if(myprovider.messagetype=="RECEIVED"){
                              myprovider.changeMessageType("SENT");
                            }
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.green,
                            size: WIDTH*0.1,
                          ),
                        ),
                      ):Expanded(
                        flex:1,
                        child: GestureDetector(
                          onTap: ()async{
                            myprovider.editMessage(editmessageindex, chattextfield.value.text);
                            myprovider.changeEditMessageFlag(false);
                            chattextfield.clear();
                          },
                          child: Icon(
                            Icons.done,
                            color: Colors.grey,
                            size: WIDTH*0.1,
                          ),
                        ),
                      ),
                      Expanded(
                        flex:1,
                        child: IconButton(
                          onPressed: ()async{
                            _image = await _picker.pickImage(source: ImageSource.gallery);
                            if(_image!=null){
                             bool result=await Navigator.push(context, MaterialPageRoute(
                                  builder: (context)=>AddTextToImage(image: _image)
                              )
                              );
                             if(result){
                               scrollDown(myprovider.controller);
                             }
                            }
                          },
                          icon:const Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Colors.blue,
                          )
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            Consumer<MyProvider>(
                builder: (context,myprovider,child){
                  return myprovider.isEmojiTriggered?SizedBox(
                    height: HEIGTH*0.3,
                    width: WIDTH,
                    child: EmojiPicker(
                      onEmojiSelected: (category, emoji) {
                        // Do something when emoji is tapped
                        chattextfield.text=chattextfield.text+emoji.emoji;
                      },
                      onBackspacePressed: () {
                        // Backspace-Button tapped logic
                        // Remove this line to also remove the button in the UI
                        chattextfield
                          ..text=chattextfield.text.characters.skipLast(1).toString()
                          ..selection=TextSelection.fromPosition(TextPosition(offset: chattextfield.text.length));
                      },
                      config: Config(
                          columns: 7,
                          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          initCategory: Category.RECENT,
                          bgColor: const Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          progressIndicatorColor: Colors.blue,
                          backspaceColor: Colors.blue,
                          skinToneDialogBgColor: Colors.white,
                          skinToneIndicatorColor: Colors.grey,
                          enableSkinTones: true,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          noRecentsText: "No Recents",
                          noRecentsStyle:
                          const TextStyle(fontSize: 20, color: Colors.black26),
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL
                      ),
                    ),
                  ):Container();
                }
            )
          ],
        ),
      ),
    );
  }
  void showEdit(BuildContext context,int index,MyProvider myProvider,TextEditingController chateditingcontroller){
    double HEIGTH=MediaQuery.of(context).size.height;
    double WIDTH=MediaQuery.of(context).size.width;
    showModalBottomSheet(
        context: context,
        builder: (context){
          return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(WIDTH*0.05)),
            child: Container(
              padding: EdgeInsets.all(WIDTH*0.03),
                height: HEIGTH*0.05,
                width: WIDTH,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        chateditingcontroller.text=myProvider.chats[index].message!;
                        myProvider.changeEditMessageFlag(true);
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: WIDTH,
                        child: const Text(
                          "Edit message",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ),
          );
        }
    );
  }
  void scrollDown(ScrollController controller){
    Future.delayed( const Duration(milliseconds: 300),(){
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    });
  }
  
  TextEditingController getTextEditingController(){
    return chattextfield;
  }
}
class AddTextToImage extends StatelessWidget {
  final chattextfield=TextEditingController();
  final XFile? image;
  final _IMAGTAGWITHTEXT="IMAGEWITHTEXT";
  
  AddTextToImage({required this.image});
  
  @override
  Widget build(BuildContext context) {
    double HEIGTH=MediaQuery.of(context).size.height;
    double WIDTH=MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue,
          leading: const Icon(
            Icons.person,
            color: Colors.white,
            size: 18,
          ),
      ),
      body: Column(
        children: [
          Consumer<MyProvider>(
            builder: (context,myprovider,child){
              return Expanded(
                child: Container(
                  color: Colors.white,
                  width: WIDTH,
                  height: HEIGTH*0.8,
                  padding: const EdgeInsets.all(5),
                  child: Center(
                    child: Image.file(
                      File(image!.path),
                      fit: BoxFit.cover,
                      height: HEIGTH*0.6,
                      width: WIDTH,
                    ),
                  ),
                ),
              );
            },
          ),
          Consumer<MyProvider>(
            builder: (context,myprovider,child){
              return Container(
                margin: const EdgeInsets.all(3),
                height: HEIGTH*0.08,
                width: WIDTH,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: HEIGTH*0.08,
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 10,
                          decoration:const InputDecoration(
                              fillColor: Colors.grey,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              )
                          ),
                          controller: chattextfield,
                          onTap: (){
                            myprovider.changeWrittingStatus(false);
                          },
                          onChanged: (val){
                            myprovider.changeWrittingStatus(false);
                          },
                          showCursor: true,
                        ),
                      ),
                    ),
                    Expanded(
                      flex:1,
                      child: GestureDetector(
                        onTap: ()async{
                            await myprovider.addChat(chattextfield.value.text,_IMAGTAGWITHTEXT,image!.path);
                            chattextfield.clear();
                            Navigator.pop(context,true);
                        },
                        onLongPress: (){
                          print("on long press");
                          if(myprovider.messagetype=="SENT"){
                            myprovider.changeMessageType("RECEIVED");
                          }else if(myprovider.messagetype=="RECEIVED"){
                            myprovider.changeMessageType("SENT");
                          }
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.green,
                          size: WIDTH*0.1,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

