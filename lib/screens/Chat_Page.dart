import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iitkms/screens/Group_Info.dart';
import 'package:iitkms/services/database_services.dart';
import 'package:iitkms/widgets/Message_Tile.dart';
import 'package:iitkms/widgets/ScreeenReplacement.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    nextScreen(
                        context,
                        GroupInfo(
                          groupId: widget.groupId,
                          groupName: widget.groupName,
                          adminName: admin,
                        ));
                  },
                  icon: const Icon(Icons.info))
            ],
            backgroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            title: Text(
              widget.groupName,
              style: TextStyle(
                  fontFamily: 'Revolin-Bold',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 27),
            )),
        resizeToAvoidBottomInset: true,
        body: Stack(children: <Widget>[
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  style:
                      GoogleFonts.poppins(color: Colors.white, fontSize: 18.0),
                  decoration: InputDecoration(
                    fillColor: Colors.grey[900],
                    filled: true,
                    hintText: "Send a message!",
                    hintStyle: GoogleFonts.poppins(
                        color: Colors.white, fontSize: 18.0),
                    border: InputBorder.none,
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
                  ),
                )
              ]),
            ),
          )
        ]));
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Container(
                padding: const EdgeInsets.only(bottom: 100),
                child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        message: snapshot.data
                                .docs[snapshot.data.docs.length - index - 1]
                            ['message'],
                        sender: snapshot.data
                                .docs[snapshot.data.docs.length - index - 1]
                            ['sender'],
                        sentByMe: widget.userName ==
                            snapshot.data
                                    .docs[snapshot.data.docs.length - index - 1]
                                ['sender']);
                  },
                ),
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
