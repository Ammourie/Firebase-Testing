import 'package:fb_testing/models/user.dart';
import 'package:fb_testing/screens/chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class ConversationList extends StatefulWidget {
  UserModel reciever;
  String name;
  String messageText;
  String imageUrl;
  DateTime time;
  bool isOnline;
  ConversationList({
    super.key,
    required this.name,
    required this.messageText,
    required this.imageUrl,
    required this.time,
    required this.reciever,
    required this.isOnline,
  });
  @override
  // ignore: library_private_types_in_public_api
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(reciever: widget.reciever),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.messageText,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: widget.isOnline
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.isOnline ? "Online" : timeago.format(widget.time),
              style: TextStyle(
                  fontSize: 12,
                  color: widget.isOnline ? Colors.green : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
