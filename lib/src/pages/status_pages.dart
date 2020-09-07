import 'package:bands_app/src/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('server status :${socketService.serverStatus}')
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // hacer el fucking emit con nombre flutter y mensaje hola desde flutter
          socketService.socket.emit('flutter',{'name':'flutter','message':'Hello from flutter'});
        },
        child: Icon(Icons.message),
      ),
    );
  }
}
