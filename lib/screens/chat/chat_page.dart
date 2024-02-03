import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

import '../../models/message.dart';
import '../../models/send_menu_item.dart';
import '../../models/user.dart';
import '../../services/chat_service.dart';
import '../../widgets/loading_widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.reciever});
  final UserModel reciever;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  TextEditingController text = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  void _scrollDown(bool animation) {
    if (_scrollController.hasClients) {
      if (animation) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
        );
      } else {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        await ChatService.updateUserStatus(
          user: UserModel(
            isOnline: true,
            lastOnline: DateTime.now(),
            image: null,
            imageUrl: null,
          ),
        );

        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        await ChatService.updateUserStatus(
          user: UserModel(
            isOnline: false,
            lastOnline: DateTime.now(),
            image: null,
            imageUrl: null,
          ),
        );
        break;

      default:
        break;
    }
  }

  List<MyMessage> _messages = [
    // MyMessage(text: "Hello, Will", isSender: true),
    // MyMessage(text: "How have you been?", isSender: true),
    // MyMessage(text: "Hey Kriss, I am doing fine dude. wbu?", isSender: false),
    // MyMessage(text: "ehhhh, doing OK.", isSender: true),
    // MyMessage(text: "Is there any thing wrong?", isSender: false),
    // MyMessage(text: "Hello, Will", isSender: true),
    // MyMessage(text: "How have you been?", isSender: true),
    // MyMessage(text: "Hey Kriss, I am doing fine dude. wbu?", isSender: false),
    // MyMessage(text: "ehhhh, doing OK.", isSender: true),
    // MyMessage(text: "Is there any thing wrong?", isSender: false),
    // MyMessage(text: "Hello, Will", isSender: true),
    // MyMessage(text: "How have you been?", isSender: true),
    // MyMessage(text: "Hey Kriss, I am doing fine dude. wbu?", isSender: false),
    // MyMessage(text: "ehhhh, doing OK.", isSender: true),
    // MyMessage(text: "Is there any thing wrong?", isSender: false),
    // MyMessage(text: "Hello, Will", isSender: true),
    // MyMessage(text: "How have you been?", isSender: true),
    // MyMessage(text: "Hey Kriss, I am doing fine dude. wbu?", isSender: false),
    // MyMessage(text: "ehhhh, doing OK.", isSender: true),
    // MyMessage(text: "Is there any thing wrong?", isSender: false),
  ];
  final UserModel _user =
      UserModel.fromFirebaseUser(FirebaseAuth.instance.currentUser!);
  List<SendMenuItems> menuItems = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Durations.medium1).then((value) => _scrollDown(true));
    menuItems = [
      SendMenuItems(
        text: "Photos",
        icons: Icons.image,
        color: Colors.amber,
        onTap: () {
          _handleImageSelection();
          _scrollDown(false);
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
          _scrollDown(false);
        },
      ),
    ];
    // _loadMessages();
  }

  _addMessage(MyMessage message) async {
    _messages.add(message);
    setState(() {});
    if (message.type == "text") {
      await ChatService.addTextMessage(message: message);
    }
    if (message.type == "image") {
      await ChatService.addImageMessage(message: message);
    }
    _scrollDown(true);
    // await NotificationService().sendNoti(
    //     body: message.text ?? "Image ig", senderId: message.senderId!);
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 200,
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
  //       createdAt: DateTime.now(),
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
      File file = File(result.path);

      final message = MyMessage(
        user: _user,
        createdAt: DateTime.now(),
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        image: file,
        senderId: _user.id,
        recId: widget.reciever.id,
        type: "image",
        width: image.width.toDouble(),
      );
      Navigator.pop(context);

      _addMessage(message);
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

  Future<void> _handleSendPressed(String text) async {
    // await NotificationService().getRecToken(widget.reciever.id!);
    final textMessage = MyMessage(
        user: _user,
        createdAt: DateTime.now(),
        id: const Uuid().v4(),
        text: text,
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

    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 10,
          // backgroundColor: Colors.white,
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
                        StreamBuilder<List<UserModel>>(
                            stream: ChatService().getAllUsersStram(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                UserModel user = snapshot.data!
                                    .where((element) =>
                                        widget.reciever.id == element.id!)
                                    .first;
                                return Text(
                                  user.isOnline
                                      ? "Online"
                                      : timeago.format(user.lastOnline!),
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13),
                                );
                              } else {
                                return Text(
                                  timeago.format(widget.reciever.lastOnline!),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: math.min(
                  MediaQuery.of(context).size.height - 3 * kToolbarHeight,
                  MediaQuery.of(context).size.height -
                      3 * kToolbarHeight -
                      MediaQuery.of(context).viewInsets.bottom),
              child: StreamProvider<List<MyMessage>>.value(
                value: ChatService().getMessages(recid: widget.reciever.id!),
                catchError: (context, error) {
                  log(error.toString());
                  return [];
                },
                initialData: [],
                child: Builder(builder: (context) {
                  _messages = Provider.of<List<MyMessage>>(context);
                  _messages.sort(
                    (a, b) => a.createdAt!.compareTo(b.createdAt!),
                  );
                  _messages.forEach((element) {
                    log(element.type!);
                  });
                  return ListView.builder(
                    primary: false,
                    controller: _scrollController,
                    itemCount: _messages.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    // physics: const NeverScrollableScrollPhysics(),

                    itemBuilder: (context, index) {
                      return _messages[index].type == "image"
                          ? BubbleNormalImage(
                              isSender: _messages[index].isSender!,
                              padding: const EdgeInsets.all(12),
                              id: _messages[index].id!,
                              image: _messages[index].imgUrl == null
                                  ? const LoadingWidget()
                                  : Image.network(
                                      _messages[index].imgUrl!,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const LoadingWidget();
                                      },
                                    ))
                          : BubbleNormal(
                              padding: const EdgeInsets.all(12),
                              color: _messages[index].isSender!
                                  ? Theme.of(context).colorScheme.inversePrimary
                                  : Colors.grey.shade200,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: _messages[index].isSender!
                                        ? Theme.of(context).primaryColor
                                        : Colors.black,
                                  ),
                              isSender: _messages[index].isSender!,
                              text: _messages[index].text!,
                            );
                    },
                  );
                }),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.all(10),
                // height: 60,
                width: double.infinity,
                // color: Colors.white,
                child: Focus(
                  onFocusChange: (value) async {
                    await Future.delayed(const Duration(milliseconds: 250));
                    _scrollDown(false);
                  },
                  child: TextFormField(
                    controller: text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.black),
                    onTap: () {},
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          if (text.text != "") {
                            setState(() {
                              // _messages.add(
                              //     MyMessage(text: text.text, isSender: true));
                              _handleSendPressed(text.text);
                              text.text = "";
                            });
                          }
                        },
                        child: const Icon(
                          EvaIcons.paperPlaneOutline,
                          size: 26,
                        ),
                      ),
                      prefixIcon: GestureDetector(
                        onTap: () {
                          _handleAttachmentPressed();
                        },
                        child: const Icon(
                          EvaIcons.attach,
                          size: 26,
                        ),
                      ),
                      hintText: " Message ...",
                      hintStyle: Theme.of(context).textTheme.bodyLarge,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // body: StreamProvider<List<MyMessage>>.value(
        //   value: ChatService().getMessages(recid: widget.reciever.id!),
        //   catchError: (context, error) {
        //     log(error.toString());
        //     return [];
        //   },
        //   initialData: [],
        //   child: Builder(builder: (context) {
        //     _messages = Provider.of<List<MyMessage>>(context);
        //     _messages.sort(
        //       (b, a) => a.createdAt!.compareTo(b.createdAt!),
        //     );
        //     _messages.forEach(
        //       (element) => log(element.toJson().toString()),
        //     );
        //     return Chat(
        //       messages: _messages
        //           .map(
        //             (e) => types.Message.fromJson(
        //               e.toJson(),
        //             ),
        //           )
        //           .toList(),
        //       // onAttachmentPressed: _handleAttachmentPressed,
        //       // onMessageTap: _handleMessageTap,
        //       // onPreviewDataFetched: _handlePreviewDataFetched,
        //       onSendPressed: _handleSendPressed,
        //       // showUserAvatars: true,
        //       // showUserNames: true,
        //       user: types.User(id: _user.id!),
        //       // isLeftStatus: true,
        //       theme: DefaultChatTheme(
        //         inputTextDecoration: InputDecoration(
        //             border: OutlineInputBorder(
        //           borderSide: BorderSide.none,
        //           borderRadius: BorderRadius.circular(10),
        //         )),
        //         seenIcon: const Text(
        //           'read',
        //           style: TextStyle(
        //             fontSize: 10.0,
        //           ),
        //         ),
        //       ),
        //     );
        //   }),
        // ),
      );
}
