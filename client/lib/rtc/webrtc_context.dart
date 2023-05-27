import 'dart:convert';

import 'package:client/constant.dart';
import 'package:client/rtc/abstract_state.dart';
import 'package:client/rtc/state/answer_state.dart';
import 'package:client/rtc/state/ice_state.dart';
import 'package:client/rtc/state/joined_state.dart';
import 'package:client/rtc/state/offer_state.dart';
import 'package:client/websocket_service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCContext {
  static final WebRTCContext _singleton = WebRTCContext._internal();

  WebRTCContext._internal();

  factory WebRTCContext() => _singleton;

  late final WebSocketService _ws = WebSocketService();

  MediaStream? _localStream;
  RTCPeerConnection? pc;

  Future init(
      RTCVideoRenderer localRenderer, RTCVideoRenderer remoteRenderer) async {
    await _initializeRenderers(localRenderer, remoteRenderer);
    final config = stunServers;

    final sdpConstraints = {
      'mandatory': {
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': true,
      },
      'optional': []
    };

    pc = await createPeerConnection(config, sdpConstraints);

    final mediaConstraints = {
      'audio': true,
      'video': {'facingMode': 'user'}
    };

    _localStream = await Helper.openCamera(mediaConstraints);

    _localStream!.getTracks().forEach((track) {
      pc!.addTrack(track, _localStream!);
    });

    localRenderer.srcObject = _localStream;

    pc!.onIceCandidate = (ice) {
      _sendIce(ice);
    };

    pc!.onAddStream = (stream) {
      remoteRenderer.srcObject = stream;
    };
  }

  Future _initializeRenderers(
      RTCVideoRenderer localRenderer, RTCVideoRenderer remoteRenderer) async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  Future _sendIce(RTCIceCandidate ice) async {
    var payload = {
      'type': 'ice',
      'candidate': ice.candidate,
      'sdpMid': ice.sdpMid,
      'sdpMLineIndex': ice.sdpMLineIndex,
    };
    _ws.send(jsonEncode(payload));
  }

  Future joinRoom() async {
    var payload = {'type': 'join'};
    _ws.send(jsonEncode(payload));
  }

  Future handleRequest(RTCState state, Map<String, dynamic> payload) async {
    switch (state.runtimeType) {
      case RTCOfferState:
        var offerState = state as RTCOfferState;
        offerState.handle(payload, pc);
        break;
      case RTCJoinedState:
        var joinedState = state as RTCJoinedState;
        joinedState.handle(payload, pc);
        break;
      case RTCIceState:
        var iceState = state as RTCIceState;
        iceState.handle(payload, pc);
        break;
      case RTCAnswerState:
        var answerState = state as RTCAnswerState;
        answerState.handle(payload, pc);
        break;
    }
  }

  void dispose() {
    _localStream?.getTracks().forEach((track) => track.stop());
    pc?.close();
  }
}
