import 'dart:convert';

import 'package:client/rtc/state/answer_state.dart';
import 'package:client/rtc/state/ice_state.dart';
import 'package:client/rtc/state/joined_state.dart';
import 'package:client/rtc/state/offer_state.dart';
import 'package:client/rtc/webrtc_context.dart';
import 'package:client/websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController myNameController = TextEditingController();
  TextEditingController targetNameController = TextEditingController();
  late final WebSocketService _ws = WebSocketService();
  late final WebRTCContext _webRTCContext = WebRTCContext();

  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    _ws.init();
    await _webRTCContext.init(_localRenderer, _remoteRenderer);
    _webRTCContext.joinRoom();
    eventListener();
  }

  Future eventListener() async {
    _ws.messageStream.listen((event) {
      var payload = jsonDecode(event);
      var type = payload['type'];
      print('Receive type: $type');
      switch (type) {
        case 'joined':
          _webRTCContext.handleRequest(RTCJoinedState(), payload);
          break;
        case 'offer':
          _webRTCContext.handleRequest(RTCOfferState(), payload);
          break;
        case 'answer':
          _webRTCContext.handleRequest(RTCAnswerState(), payload);
          break;
        case 'ice':
          _webRTCContext.handleRequest(RTCIceState(), payload);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            // width: 300,
            // height: 400,
            color: Colors.blue,
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                RTCVideoView(_localRenderer),
                Positioned(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 150,
                          height: 200,
                          child: RTCVideoView(_remoteRenderer),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void disconnect() {
    _webRTCContext.dispose();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
    _ws.dispose();
  }
}
