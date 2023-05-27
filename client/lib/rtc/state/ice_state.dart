import 'package:client/rtc/abstract_state.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class RTCIceState implements RTCState {
  @override
  Future handle(Map<String, dynamic> payload, RTCPeerConnection? pc) async {
    var candidate = RTCIceCandidate(
        payload['candidate'], payload['sdpMid'], payload['sdpMLineIndex']);
    await pc!.addCandidate(candidate);
  }

  @override
  Future response(RTCPeerConnection? pc) {
    // TODO: implement response
    throw UnimplementedError();
  }
}
