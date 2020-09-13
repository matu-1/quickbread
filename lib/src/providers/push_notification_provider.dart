import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  static final _pushProvider = new PushNotificationProvider._internal();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _messageStreamController = StreamController<Map>.broadcast();

  factory PushNotificationProvider() => _pushProvider;
  PushNotificationProvider._internal();

  Stream<Map> get messageStream => _messageStreamController.stream;
  set messageChange(Map message) => _messageStreamController.sink.add(message);

  void initNotitication(Function(String) onToken) {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then(onToken);
    _firebaseMessaging.configure(
      onMessage: (message) async {
        //cuando la app esta abierta
        print('==== ON_MESSAGE ====');
        message['type'] = 'onMessage';
        messageChange = message;
      },
      onLaunch: (message) async {
        //cuando se abre la app por primera vez cuando se toca lo notificacion
        print('==== ON_LAUNCH ====');
        messageChange = message;
      },
      onResume: (message) async {
        //cuando se toca la notificacion
        print('==== ON_RESUME ====');
        messageChange = message;
      },
    );
  }

  void dispose() {
    _messageStreamController.close();
  }
}

//token=dLzrL6Q1QKuQiRExBFARu-:APA91bEWIHfPzcpXVDXY6yPGZkRQrwfYjCOjC5Dvj0srXWYhEPVpEtuR00t43AdPuD39RxadgWBFSkxsk24Vdop4kGLbVSx4bskPevH11b8-hcRaVI6H-OttLM2uBqlPiviiSAi09lCa
