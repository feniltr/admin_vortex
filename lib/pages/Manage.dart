import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Manage extends StatefulWidget {
  const Manage({Key? key}) : super(key: key);

  @override
  State<Manage> createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  late TextEditingController _computersController;
  late TextEditingController _roomsController;
  late TextEditingController _gameStationsController;

  @override
  void initState() {
    super.initState();

    fetchDataFromFirestore();

    _computersController = TextEditingController();
    _roomsController = TextEditingController();
    _gameStationsController = TextEditingController();
  }

  void fetchDataFromFirestore() async {
    FirebaseFirestore.instance.collection('unit').doc('id').get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        _computersController.text = data['computers'] ?? '';
        _roomsController.text = data['rooms'] ?? '';
        _gameStationsController.text = data['gameroom'] ?? '';
      } else {
        print('Document does not exist');
      }
    }).catchError((error) {
      print('Error fetching document: $error');
    });
  }

  void updatezones() {
    String computers = _computersController.text;
    String rooms = _roomsController.text;
    String gamerooms = _gameStationsController.text;

    FirebaseFirestore.instance.collection('unit').doc('id').update({
      'computers': computers,
      'rooms': rooms,
      'gameroom' : gamerooms,
    }).then((value) {
      print('Document successfully updated!');
    }).catchError((error) {
      print('Error updating document: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Update Zones",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        buildRow("Computers", _computersController),
        buildRow("Rooms", _roomsController),
        buildRow("Game Stations", _gameStationsController),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  updatezones();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: Text("Update", style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildRow(String labelText, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              labelText,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
