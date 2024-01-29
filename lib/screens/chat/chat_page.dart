import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fb_testing/models/message.dart';
import 'package:fb_testing/models/send_menu_item.dart';
import 'package:fb_testing/models/user.dart';
import 'package:fb_testing/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.reciever});
  final UserModel reciever;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<MyMessage> _messages = [];
  final UserModel _user =
      UserModel.fromFirebaseUser(FirebaseAuth.instance.currentUser!);
  List<SendMenuItems> menuItems = [];

  @override
  void initState() {
    super.initState();
    menuItems = [
      SendMenuItems(
        text: "Photos",
        icons: Icons.image,
        color: Colors.amber,
        onTap: () {
          _handleImageSelection();
        },
      ),
      // SendMenuItems(
      //   text: "Document",
      //   icons: Icons.insert_drive_file,
      //   color: Colors.blue,
      //   onTap: _handleFileSelection,
      // ),
      // SendMenuItems(
      //   text: "Audio",
      //   icons: Icons.music_note,
      //   color: Colors.orange,
      //   onTap: () {},
      // ),
      SendMenuItems(
        text: "Cancel",
        icons: EvaIcons.close,
        color: Colors.red,
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ];
    // _loadMessages();
  }

  _addMessage(MyMessage message) async {
    _messages.insert(0, message);

    setState(() {});
    await ChatService.addTextMessage(message: message);
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 3.2,
            color: const Color(0xff737373),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    itemCount: menuItems.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: ListTile(
                          onTap: menuItems[index].onTap,
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: menuItems[index].color.shade50,
                            ),
                            height: 50,
                            width: 50,
                            child: Icon(
                              menuItems[index].icons,
                              size: 25,
                              color: menuItems[index].color.shade400,
                            ),
                          ),
                          title: Text(menuItems[index].text),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
    // showModalBottomSheet<void>(
    //   backgroundColor: Colors.white,
    //   context: context,
    //   builder: (BuildContext context) => SafeArea(
    //     child: SizedBox(
    //       height: 144,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: <Widget>[
    //           TextButton(
    //             onPressed: () {
    //               Navigator.pop(context);
    //               _handleImageSelection();
    //             },
    //             child: const Align(
    //               alignment: AlignmentDirectional.centerStart,
    //               child: Text('Photo'),
    //             ),
    //           ),
    //           TextButton(
    //             onPressed: () {
    //               Navigator.pop(context);
    //               _handleFileSelection();
    //             },
    //             child: const Align(
    //               alignment: AlignmentDirectional.centerStart,
    //               child: Text('File'),
    //             ),
    //           ),
    //           TextButton(
    //             onPressed: () => Navigator.pop(context),
    //             child: const Align(
    //               alignment: AlignmentDirectional.centerStart,
    //               child: Text('Cancel'),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  // void _handleAttachmentPressed() {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) => SafeArea(
  //       child: SizedBox(
  //         height: 120,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: <Widget>[
  //             ListTile(
  //               tileColor: Colors.green.shade200,
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 _handleImageSelection();
  //               },
  //               title: const Align(
  //                 alignment: AlignmentDirectional.centerStart,
  //                 child: Text('Photo'),
  //               ),
  //             ),
  //             // TextButton(
  //             //   onPressed: () {
  //             //     Navigator.pop(context);
  //             //     _handleFileSelection();
  //             //   },
  //             //   child: const Align(
  //             //     alignment: AlignmentDirectional.centerStart,
  //             //     child: Text('File'),
  //             //   ),
  //             // ),
  //             ListTile(
  //               tileColor: Colors.red.shade200,
  //               onTap: () => Navigator.pop(context),
  //               title: const Align(
  //                 alignment: AlignmentDirectional.centerStart,
  //                 child: Text('Cancel'),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // void _handleFileSelection() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.any,
  //   );

  //   if (result != null && result.files.single.path != null) {
  //     final message = types.FileMessage(
  //       author: _user,
  //       createdAt: DateTime.now().millisecondsSinceEpoch,
  //       id: const Uuid().v4(),
  //       mimeType: lookupMimeType(result.files.single.path!),
  //       name: result.files.single.name,
  //       size: result.files.single.size,
  //       uri: result.files.single.path!,
  //     );

  //     _addMessage(message);
  //   }
  // }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = MyMessage(
        user: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        senderId: _user.id,
        recId: widget.reciever.id,
        type: "image",
        width: image.width.toDouble(),
      );

      _addMessage(message);
      Navigator.pop(context);
    }
  }

  // void _handleMessageTap(BuildContext _, types.Message message) async {
  //   if (message is types.FileMessage) {
  //     var localPath = message.uri;

  //     if (message.uri.startsWith('http')) {
  //       try {
  //         final index =
  //             _messages.indexWhere((element) => element.id == message.id);
  //         final updatedMessage =
  //             (_messages[index] as types.FileMessage).copyWith(
  //           isLoading: true,
  //         );

  //         setState(() {
  //           _messages[index] = updatedMessage;
  //         });

  //         final client = http.Client();
  //         final request = await client.get(Uri.parse(message.uri));
  //         final bytes = request.bodyBytes;
  //         final documentsDir = (await getApplicationDocumentsDirectory()).path;
  //         localPath = '$documentsDir/${message.name}';

  //         if (!File(localPath).existsSync()) {
  //           final file = File(localPath);
  //           await file.writeAsBytes(bytes);
  //         }
  //       } finally {
  //         final index =
  //             _messages.indexWhere((element) => element.id == message.id);
  //         final updatedMessage =
  //             (_messages[index] as types.FileMessage).copyWith(
  //           isLoading: null,
  //         );

  //         setState(() {
  //           _messages[index] = updatedMessage;
  //         });
  //       }
  //     }

  //     await OpenFilex.open(localPath);
  //   }
  // }

  // void _handlePreviewDataFetched(
  //   types.TextMessage message,
  //   types.PreviewData previewData,
  // ) {
  //   final index = _messages.indexWhere((element) => element.id == message.id);
  //   final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
  //     previewData: previewData,
  //   );

  //   setState(() {
  //     _messages[index] = updatedMessage;
  //   });
  // }

  void _handleSendPressed(types.PartialText message) {
    log(DateTime.now().millisecondsSinceEpoch.toString());
    final textMessage = MyMessage(
        user: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: message.text,
        type: "text",
        senderId: _user.id,
        recId: widget.reciever.id);

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => MyMessage.fromJson(e as Map<String, dynamic>))
        .toList();
    messages.forEach(
      (element) => log(element.toJson().toString()),
    );
    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(right: 5),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.reciever.image ?? ''),
                    maxRadius: 20,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.reciever.name!,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          "Online",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: StreamProvider<List<MyMessage>>.value(
          value: ChatService().getMessages(recid: widget.reciever.id!),
          catchError: (context, error) {
            log(error.toString());
            return [];
          },
          initialData: [],
          child: Builder(builder: (context) {
            _messages = Provider.of<List<MyMessage>>(context);
            _messages.sort(
              (b, a) => a.createdAt!.compareTo(b.createdAt!),
            );
            _messages.forEach(
              (element) => log(element.toJson().toString()),
            );
            return Chat(
              messages: _messages
                  .map(
                    (e) => types.Message.fromJson(
                      e.toJson(),
                    ),
                  )
                  .toList(),
              // onAttachmentPressed: _handleAttachmentPressed,
              // onMessageTap: _handleMessageTap,
              // onPreviewDataFetched: _handlePreviewDataFetched,
              onSendPressed: _handleSendPressed,
              // showUserAvatars: true,
              // showUserNames: true,
              user: types.User(id: _user.id!),
              // isLeftStatus: true,
              theme: DefaultChatTheme(
                inputTextDecoration: InputDecoration(
                    border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                )),
                seenIcon: const Text(
                  'read',
                  style: TextStyle(
                    fontSize: 10.0,
                  ),
                ),
              ),
            );
          }),
        ),
      );
}
