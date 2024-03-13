import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PriceUpdate extends StatefulWidget {
  const PriceUpdate({Key? key}) : super(key: key);

  @override
  State<PriceUpdate> createState() => _PriceUpdateState();
}

class _PriceUpdateState extends State<PriceUpdate> {
  TextEditingController commonZoneController = TextEditingController();
  TextEditingController privateZoneController = TextEditingController();
  TextEditingController gameZoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchdata();
  }

  void fetchdata() {
    FirebaseFirestore.instance.collection('ZonePrice').doc('prices').get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        int c = data['commanzone'] ?? '';
        commonZoneController.text = c.toString();
        int p = data['privatezone'] ?? '';
        privateZoneController.text = p.toString();
        int g = data['gamestation'] ?? '';
        gameZoneController.text = g.toString();
      } else {
        print('Document does not exist');
      }
    }).catchError((error) {
      print('Error fetching document: $error');
    });
  }

  
    void updateprice() {
      String c = commonZoneController.text;
      String p = privateZoneController.text;
      String g = gameZoneController.text;

      // Update Firestore collection 'OpenHourTime'
      FirebaseFirestore.instance.collection('ZonePrice').doc('prices').update({
        'commanzone': int.parse(c),
        'privatezone': int.parse(p),
        'gamestation': int.parse(g)
      }).then((value) {
        print('Document successfully updated!');
      }).catchError((error) {
        print('Error updating document: $error');
      });
    }
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Set Price",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              _buildPriceRow(
                labelText: 'Common Zone Price',
                controller: commonZoneController,
              ),
              _buildPriceRow(
                labelText: 'Private Zone Price',
                controller: privateZoneController,
              ),
              _buildPriceRow(
                labelText: 'Game Station Price',
                controller: gameZoneController,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  updateprice();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: Text("Update", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow({
    required String labelText,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              labelText,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            flex: 1,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 16.0),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
