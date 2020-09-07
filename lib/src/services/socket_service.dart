import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum  ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier{
 ServerStatus _serverStatus = ServerStatus.Connecting;
 IO.Socket _socket;
 SocketService(){
  _initConfig();
 }

 ServerStatus get serverStatus => _serverStatus;
 IO.Socket get socket => _socket;

 void _initConfig(){
    _socket = IO.io('http://192.168.1.9:3000/',{
      'transports': ['websocket'],
      'extraHeaders': {'foo': 'bar'},
      'autoConnect': true
    });
    _socket.on('connect',(_){
      print('connected');
      _socket.emit('msg','text');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.on('event', (data) => print(data));
    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    _socket.on('message',(data)=> print(data));
    
    _socket.emit('hello',{"name":"julian"});

    _socket.on('hello',(data)=> print(data));
 }
}