import 'package:client/rtc/abstract_state.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class RTCAnswerState implements RTCState {
  @override
  Future handle(Map<String, dynamic> payload, RTCPeerConnection? pc) async {
    var description = RTCSessionDescription(payload['sdp'], payload['type']);
    await pc!.setRemoteDescription(description);
  }

  @override
  Future response(RTCPeerConnection? pc) {
    // TODO: implement response
    throw UnimplementedError();
  }
}
