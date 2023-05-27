import 'dart:convert';

import 'package:client/rtc/abstract_state.dart';
import 'package:client/websocket_service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class RTCOfferState implements RTCState {
  late final WebSocketService _ws = WebSocketService();

  @override
  Future handle(Map<String, dynamic> payload, RTCPeerConnection? pc) async {
    var description = RTCSessionDescription(payload['sdp'], payload['type']);
    await pc!.setRemoteDescription(description);
    await response(pc);
  }

  @override
  Future response(RTCPeerConnection? pc) async {
    print('send answer');
    var answer = await pc!.createAnswer();
    pc.setLocalDescription(answer);
    var payload = {'type': answer.type, 'sdp': answer.sdp};
    _ws.send(jsonEncode(payload));
  }
}
