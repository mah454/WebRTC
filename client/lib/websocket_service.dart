import 'dart:async';
import 'dart:convert';

import 'package:client/constant.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  static final WebSocketService _singleton = WebSocketService._internal();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  factory WebSocketService() => _singleton;

  WebSocketService._internal();

  late final Uri uri;
  late final WebSocketChannel ws;
  late final StreamController<String> _messageController =
      StreamController<String>.broadcast();
  late final Stream<String> _messageStream;

  Stream<String> get messageStream => _messageController.stream;

  void init() {
    String wsUrl = 'ws://$serverBaseUrl/webrtc/signal/';
    print('Connect to $wsUrl');
    uri = Uri.parse(wsUrl);
    ws = WebSocketChannel.connect(uri);
    _messageStream = ws.stream.cast<String>();
    _messageStream.listen((event) {
      _messageController.add(event);
    });
  }

  bool isConnected() {
    return ws.closeCode == null && ws.closeReason == null;
  }

  void send(String msg) {
    ws.sink.add(msg);
  }

  void dispose() {
    ws.sink.close();
    _messageController.close();
  }
}
