import 'package:bands_app/src/models/band.dart';
import 'package:bands_app/src/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _bandInput = '';

  List<Band> _bands = [
    // new Band(id: 'jf3', votes: 23, name: 'TameImpala'),
    // new Band(id: '2344', name: 'Sliptnok', votes: 23),
    // new Band(id: '23244', name: 'Quenn', votes: 5),
  ];

  @override
  void initState() {
    // TODO: implement initState
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('bands', _handleActiveBands);

    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    this._bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Bands',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  )
                : Icon(
                    Icons.check_circle,
                    color: Colors.red,
                  ),
          )
        ],
      ),
      body: Column(
        children: [
          _renderGraphic(),
          Expanded(
            child: ListView.builder(
                itemCount: _bands.length,
                itemBuilder: (context, item) {
                  Band band = _bands[item];
                  return _renderListile(band);
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addBand(),
        child: Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

  Widget _renderListile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print(direction);
        socketService.socket.emit('delete-band', {"id": band.id});
      },
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            )),
      ),
      child: ListTile(
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 18),
        ),
        onTap: () {
          print(band.id);
          socketService.socket.emit('vote-band', {"id": band.id});
        },
      ),
    );
  }

  addBand() {
    final textController = new TextEditingController();
    final socketService = Provider.of<SocketService>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add new band"),
            content: TextField(
              controller: textController,
              onChanged: (value) {
                setState(() {
                  _bandInput = value;
                });
              },
            ),
            actions: [
              MaterialButton(
                child: Text('Add'),
                onPressed: () {
                  // addBandToList(textController.text);
                  socketService.socket
                      .emit('add-band', {'name': textController.text});
                  Navigator.of(context, rootNavigator: true).pop();
                },
                elevation: 5,
                textColor: Colors.blue,
              )
            ],
          );
        });
  }

  addBandToList(String bandName) {
    if (bandName.length > 1) {
      Band newBand = new Band(votes: 0, name: bandName, id: '123423');

      setState(() {
        _bands.add(newBand);
      });
    }
  }

  _renderGraphic() {
    Map<String, double> dataMap = new Map();

    _bands.forEach((element) {
    dataMap.putIfAbsent(element.name, () => element.votes.toDouble());
    });

    return dataMap.isNotEmpty ? Container(
      height: 200,
      child: PieChart(
        dataMap: dataMap,
      ),
    ): Container();
  }
}
