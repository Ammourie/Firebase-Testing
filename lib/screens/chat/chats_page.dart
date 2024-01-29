import 'dart:developer';

import 'package:fb_testing/models/user.dart';
import 'package:fb_testing/screens/chat/chat_list_tile.dart';
import 'package:fb_testing/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  // final List<UserModel> user = [
  //   UserModel(
  //     isOnline: false,
  //     id: '1',
  //     name: "Ammourie",
  //     email: "mohammed.ammourie@gmail.com",
  //     image:
  //         "https://i.etsystatic.com/34732889/r/il/b08942/3768265623/il_570xN.3768265623_sji1.jpg",
  //     lastOnline: DateTime.now().subtract(const Duration(days: 10)),
  //     phoneNumber: "+963933564291",
  //   ),
  //   UserModel(
  //     isOnline: true,
  //     id: '2',
  //     name: "khaled",
  //     email: "mohammed.ammourie2@gmail.com",
  //     image:
  //         "https://pics.craiyon.com/2023-07-19/372d10a1044941c0a471ac071b686a6a.webp",
  //     lastOnline: DateTime.now(),
  //     phoneNumber: "+963933564291",
  //   ),
  //   UserModel(
  //     isOnline: false,
  //     id: '3',
  //     name: "Samira",
  //     email: "mohammed.ammourie2@gmail.com",
  //     image: "https://avatars.pfptown.com/649/grunge-pfp-3302.png",
  //     lastOnline: DateTime.now(),
  //     phoneNumber: "+963933564291",
  //   ),
  //   UserModel(
  //     isOnline: true,
  //     id: '4',
  //     name: "Nour",
  //     email: "mohammed.ammourie2@gmail.com",
  //     image:
  //         "https://i.redd.it/best-boy-and-best-girl-of-season-7-my-pfp-says-it-v0-6x9yfkhtlswa1.jpg?width=677&format=pjpg&auto=webp&s=fbbe6510279f0f46e3db152d876f15531cde0d7a",
  //     lastOnline: DateTime.now(),
  //     phoneNumber: "+963933564291",
  //   ),
  // ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: StreamProvider<List<UserModel>>.value(
        catchError: (context, error) {
          log("error: " + error.toString());
          return [];
        },
        value: ChatService().getAllUsersStram(),
        initialData: [],
        child: Builder(builder: (context) {
          List<UserModel> users = Provider.of<List<UserModel>>(context);
          log(users.length.toString());
          return ListView.builder(
            itemCount: users.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 16),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return FirebaseAuth.instance.currentUser!.uid == users[index].id
                  ? const SizedBox()
                  : ConversationList(
                      reciever: users[index],
                      name: users[index].name ?? "",
                      messageText: "",
                      imageUrl: users[index].image ?? "",
                      time: users[index].lastOnline!,
                      isOnline: users[index].isOnline,
                    );
            },
          );
        }),
      ),
    );
  }
}
