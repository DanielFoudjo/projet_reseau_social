import 'package:flutter/foundation.dart';

class MessageModel {
  final String from;
  final String to;
  final DateTime timestamp;
  final String contents;
  String _id;
  String get id => _id;

  MessageModel(this._id, {
    required this.from,
    required this.to,
    required this.timestamp,
    required this.contents,
  });

  toJson() => {
    'from': this.from,
    'to': this.to,
    'timestamp': this.timestamp,
    'contents': this.contents
  };

  factory MessageModel.fromJson(Map<String, dynamic> json){

    var message = MessageModel(
      json['id'],
      from: json['from'], 
      to: json['to'], 
      timestamp: json['timestamp'],
      contents: json['contents']);
    message._id = json['id'];
    return message;
  }

}