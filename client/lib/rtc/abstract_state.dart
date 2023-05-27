import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class RTCState {
  Future handle(Map<String, dynamic> payload, RTCPeerConnection? pc);

  Future response(RTCPeerConnection? pc);
}
