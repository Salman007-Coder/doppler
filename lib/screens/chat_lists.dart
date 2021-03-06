import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:dopplerv1/consts/collections.dart';
import 'package:dopplerv1/consts/universal_variables.dart';
import 'package:dopplerv1/inner_screens/comments_n_chat.dart';

class ChatLists extends StatefulWidget {
  @override
  _ChatListsState createState() => _ChatListsState();
}

class _ChatListsState extends State<ChatLists> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("All Chats"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream:
              chatListRef.orderBy("timestamp", descending: true).snapshots(),
          builder: (context, snapshots) {
            if (!snapshots.hasData) {
              return LoadingIndicator();
            }
            List<CommentsNMessages> chatHeads = [];
            print(snapshots.data);
            snapshots.data!.docs.forEach((e) {
              print("in snapshot");
              // print(e.data()["userId"]);
              setState(() {
                chatHeads.add(CommentsNMessages.fromDocument(e));
              });
              print(chatHeads);
            });
            if (snapshots.data == null || chatHeads.isEmpty) {
              return Center(
                child: Text(
                  "No Active Chat Heads!!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              );
            }

            return ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: chatHeads.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommentsNChat(
                                  isPostComment: false,
                                  isProductComment: false,
                                  chatId: chatHeads[index].userId,
                                  chatNotificationToken:
                                      chatHeads[index].androidNotificationToken,
                                  heroMsg: chatHeads[index].comment,
                                ))),
                    child: GlassContainer(
                      opacity: 0.6,
                      child: ListTile(
                        leading: Hero(
                          tag: chatHeads[index].comment!,
                          child: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                        ),
                        title: Text(chatHeads[index].userName!),
                        subtitle: Text(
                          chatHeads[index].comment!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
