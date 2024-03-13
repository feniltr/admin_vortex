import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactUpdate extends StatefulWidget {
  const ContactUpdate({Key? key}) : super(key: key);

  @override
  State<ContactUpdate> createState() => _ContactUpdateState();
}

class _ContactUpdateState extends State<ContactUpdate> {
  late TextEditingController _phoneNumberController;


  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();

    fetchDataFromFirestore();
  }

  void fetchDataFromFirestore() async {
    FirebaseFirestore.instance.collection('contanct').doc('number').get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        _phoneNumberController.text = data['callnum'] ?? '';

      } else {
        print('Document does not exist');
      }
    }).catchError((error) {
      print('Error fetching document: $error');
    });
  }

  void updatenumber() {
    String c = _phoneNumberController.text;

    FirebaseFirestore.instance.collection('contanct').doc('number').update({
      'callnum': c,
    }).then((value) {
      print('Document successfully updated!');
    }).catchError((error) {
      print('Error updating document: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Set Contact Number",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          SizedBox(height: 15,),

          TextField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Enter phone number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                  updatenumber();
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
