import 'dart:convert';

import 'package:client/rtc/abstract_state.dart';
import 'package:client/websocket_service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class RTCJoinedState implements RTCState {
  late final WebSocketService _ws = WebSocketService();

  @override
  Future handle(Map<String, dynamic> payload, RTCPeerConnection? pc) async {
    await response(pc);
  }

  @override
  Future response(RTCPeerConnection? pc) async {
    print('send offer');
    var offer = await pc!.createOffer();
    pc.setLocalDescription(offer);
    var payload = {'type': offer.type, 'sdp': offer.sdp};
    _ws.send(jsonEncode(payload));
  }
}
