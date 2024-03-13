import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class setTime extends StatefulWidget {
  const setTime({Key? key}) : super(key: key);

  @override
  State<setTime> createState() => _setTimeState();
}

class _setTimeState extends State<setTime> {
  TextEditingController openHour = TextEditingController();
  TextEditingController closeHour = TextEditingController();
  String status = 'Open'; // Default status

  @override
  void initState() {
    super.initState();

    fetchOpenHourTime();
  }

  void fetchOpenHourTime() {
    FirebaseFirestore.instance.collection('OpenHourTime').doc('doc').get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        openHour.text = data['opentime'] ?? '';
        closeHour.text = data['closetime'] ?? '';
        status = data['status'] ?? 'Open';
        setState(() {

        });
      } else {
        print('Document does not exist');
      }
    }).catchError((error) {
      print('Error fetching document: $error');
    });
  }

  void updateOpenHourTime() {
    String openTime = openHour.text;
    String closeTime = closeHour.text;

    // Update Firestore collection 'OpenHourTime'
    FirebaseFirestore.instance.collection('OpenHourTime').doc('doc').update({
      'opentime': openTime,
      'closetime': closeTime,
      'status': status, // Update the status field
    }).then((value) {
      print('Document successfully updated!');
    }).catchError((error) {
      print('Error updating document: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            // Add your shadow properties if needed
          ),
        ],
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Set Time of Cafe",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextField(
                    controller: openHour,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Open Time',
                      labelText: 'Open Time',
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextField(
                    controller: closeHour,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Close Time',
                      labelText: 'Close Time',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // Radio buttons for status
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                value: 'Open',
                groupValue: status,
                onChanged: (value) {
                  setState(() {
                    status = 'Open';
                  });
                },
              ),
              Text('Open'),
              SizedBox(width: 10),
              Radio(
                value: 'Closed',
                groupValue: status,
                onChanged: (value) {
                  setState(() {
                    status = 'Closed';
                  });
                },
              ),
              Text('Closed'),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                updateOpenHourTime();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: Text("Update", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
