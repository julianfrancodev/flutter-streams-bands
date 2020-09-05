import 'package:bands_app/src/models/band.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _bandInput = '';

  List<Band> _bands = [
    new Band(id: 'jf3', votes: 23, name: 'TameImpala'),
    new Band(id: '2344', name: 'Sliptnok', votes: 23),
    new Band(id: '23244', name: 'Quenn', votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
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
      ),
      body: ListView.builder(
          itemCount: _bands.length,
          itemBuilder: (context, item) {
            Band band = _bands[item];
            return _renderListile(band);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addBand(),
        child: Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

  Widget _renderListile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        print(direction);
        // TODO: call the server to delete
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
          print(band.name);
        },
      ),
    );
  }

  addBand() {
    final textController = new TextEditingController();
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
                  addBandToList(textController.text);
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
}
