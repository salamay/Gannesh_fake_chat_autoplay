import 'package:flutter/cupertino.dart';
import 'package:ganeshchatap/ChatModel.dart';

class MyProvider extends ChangeNotifier{
  late String recipent;
  late List<ChatModel> chats=[];
  String messagetype="SENT";
  bool isEmojiTriggered=false;
  bool editMessageFlag=false;
  ScrollController controller = ScrollController();
  List<ChatModel> tempList=[];
  bool isAutoplay=false;
  
  void changeRecipent(String name){
    recipent=name;
  }
  
  Future<void> addChat(String message,String tag,String? imagepath)async {
    ChatModel chatModel=ChatModel(messagetype,message,tag,imagepath);
    chats.add(chatModel);
    notifyListeners();
  }
  void changeMessageType(String type){
    messagetype=type;
    notifyListeners();
  }
  void clearChat()async{
    chats.clear();
    notifyListeners();
  }
  void changeWrittingStatus(bool status){
    isEmojiTriggered=status;
    notifyListeners();
  }
  
  void editMessage(int index,String message){
    ChatModel chatModel=chats.elementAt(index);
    chatModel.message=message;notifyListeners();
  }
  void changeEditMessageFlag(bool status){
    editMessageFlag=status;
    notifyListeners();
  }
  
  void startAutoPlay(TextEditingController textEditingController)async{
    changeAutoplay(true);
    chats.map((e){
      tempList.add(e);
    }).toList();
    clearChat();
    Future.delayed(const Duration(seconds: 2),(){
      proceedAutoPlayChat(tempList,textEditingController);
    });
  }
  
  void proceedAutoPlayChat(List<ChatModel> list,TextEditingController textEditingController)async{
    for(int i=0;i<list.length;i++){
      if(list[i].messagetype=="SENT"){
        //Get message
        String message=list[i].message!;
        await typeMessage(message, textEditingController);
        await Future.delayed(const Duration(milliseconds: 200),(){
          add(list[i]);
          textEditingController.clear();
          scrollDown();
          if(i==tempList.length-1){
            changeAutoplay(false);
          }
        });
      }else{
        await Future.delayed(const Duration(seconds: 2),(){
          add(list[i]);
          scrollDown();
        });
        
      }
    }
  }
  void add(ChatModel chatModel){
    chats.add(chatModel);
    notifyListeners();
  }
  Future<void> typeMessage(String message,TextEditingController textEditingController)async{
    for(int i=0;i<message.length;i++){
      await Future.delayed(const Duration(milliseconds: 150),(){
        String char=message.substring(i,i+1);
        textEditingController.text=textEditingController.text+char;
      });
    }
  }
  void scrollDown(){
    Future.delayed( const Duration(milliseconds: 300),(){
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    });
  }
  void changeAutoplay(bool status){
    isAutoplay=status;
    notifyListeners();
  }
}