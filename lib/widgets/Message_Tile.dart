import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;

  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sentByMe})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.sentByMe ? 0 : 24,
          right: widget.sentByMe ? 24 : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 20),
        decoration: BoxDecoration(
            borderRadius: widget.sentByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))
                : const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
            color: widget.sentByMe
                ? Color.fromARGB(255, 96, 117, 250)
                : Color.fromARGB(255, 91, 91, 91)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontFamily: 'Helvetica-Bold',
                fontSize: 13,
                color: Colors.white,
              ),
            ),
            Text(widget.message,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontFamily: 'Helvetica', fontSize: 16, color: Colors.white))
          ],
        ),
      ),
    );
  }
}
