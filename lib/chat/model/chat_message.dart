import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String message_body_;
  final String message_type_;
  final String recever_id_;
  final String sender_id_;
  final String time_;
  final AnimationController animationController;

  ChatMessage({
    String message_body,
    String message_type,
    String recever_id,
    String sender_id,
    String time,
    AnimationController animationController,
  })  : message_body_ = message_body,
        message_type_ = message_type,
        recever_id_ = recever_id,
        sender_id_ = sender_id,
        time_ = time,
        animationController = animationController;

  Map<String, dynamic> toMap() => {'message_body': message_body_,
    'message_type': message_type_,
    'recever_id': recever_id_,
    'sender_id': sender_id_,
    'time': time_,
  };

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(backgroundColor: Colors.pink,)),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: message_type_ == "TYPE_TEXT"
                          ? Text(message_body_)
                          : Image.network(message_body_),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
