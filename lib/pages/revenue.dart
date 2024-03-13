import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Revenue extends StatefulWidget {
  const Revenue({Key? key}) : super(key: key);

  @override
  State<Revenue> createState() => _RevenueState();
}

class _RevenueState extends State<Revenue> {
  int monthlyTotal = 0;
  late int todayTotal = 0;

  @override
  void initState() {
    super.initState();

    fetchMonthlyCollectionData();
    fetchTodayCollectionData();
  }

  Future<void> fetchMonthlyCollectionData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get the current date
    DateTime currentDate = DateTime.now();

    // Calculate the first day of the current month
    DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);

    // Construct a query to fetch documents where the 'timestamp' field is within the current month
    QuerySnapshot querySnapshot = await firestore
        .collection("Transactions")
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
        .get();



    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data != null) {
        int foo = data['total'];
        monthlyTotal += foo;
      }
    }

    print("Monthly Total: $monthlyTotal");
  }

  Future<void> fetchTodayCollectionData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get the current date in the format 'yyyy-MM-dd'
    String todayDate = DateTime.now().toLocal().toIso8601String().substring(0, 10);

    // Initialize todayTotal before using it

    // Construct a query to fetch documents where the 'timestamp' field is equal to today
    QuerySnapshot querySnapshot = await firestore
        .collection("Transactions")
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.parse(todayDate)))
        .where('timestamp', isLessThan: Timestamp.fromDate(DateTime.parse(todayDate + 'T23:59:59')))
        .get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data != null) {
        int foo = data['total'];
        todayTotal += foo;
        setState(() {

        });
      }
    }

    print("Today's Total: $todayTotal");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF3B3BFD), Color(0xFF00AEFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      height: 100,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Monthly\'s Revenue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\₹ ${monthlyTotal}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF28FFBF), Color(0xFF00FF91)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      height: 100,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Today\'s Revenue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\₹ ${todayTotal}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('Transactions').get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                // Data is ready
                final List<DocumentSnapshot> documents = snapshot.data!.docs;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Total')),
                      DataColumn(label: Text('Time Slot')),
                      DataColumn(label: Text('Zone ID')),
                      DataColumn(label: Text('Timestamp')),
                      DataColumn(label: Text('Zone')),
                    ],
                    rows: documents.map((doc) {
                      return DataRow(
                        cells: [
                          DataCell(Text(doc['Email'].toString())),
                          DataCell(Text(doc['total'].toString())),
                          DataCell(Text(doc['TimeSlot'].toString())),
                          DataCell(Text(doc['ZoneId'].toString())),
                          DataCell(
                            Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(doc['timestamp'].toDate())),
                          ),
                          DataCell(Text(doc['zone'].toString())),
                        ],
                      );
                    }).toList(),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
