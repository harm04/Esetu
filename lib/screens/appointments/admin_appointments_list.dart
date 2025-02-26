
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminAppointmentsList extends StatefulWidget {
  const AdminAppointmentsList({super.key});

  @override
  State<AdminAppointmentsList> createState() => _AdminAppointmentsListState();
}

class _AdminAppointmentsListState extends State<AdminAppointmentsList> {
  // Function to fetch customer name from Firestore
  Future<String> _getCustomerName(String customerUID) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(customerUID)
          .get();

      if (userSnapshot.exists) {
        var userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('firstName') && userData.containsKey('lastName')) {
          return '${userData['firstName']} ${userData['lastName']}';
        }
      }
      return 'Unknown Customer';
    } catch (e) {
      return 'Unknown Customer';
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Appointments'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Updates')
            .where('setuUID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No appointments found.'));
          }

          var appointments = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                var data = appointments[index].data() as Map<String, dynamic>?;

                if (data == null || !data.containsKey('customerUID') || !data.containsKey('updateId')) {
                  return const SizedBox.shrink(); // Skip if data is invalid
                }

                String customerUID = data['customerUID'];
               // Unique ID of appointment

                return FutureBuilder<String>(
                  future: _getCustomerName(customerUID), // Fetch customer name
                  builder: (context, nameSnapshot) {
                    String customerName = nameSnapshot.data ?? 'Loading...';

                    return Card(
                     color: Colors.grey[300],
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(
                          customerName, // Display fetched customer name
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        subtitle: Text(
                          data['document'],
                          style: const TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          // Handle appointment tap
                        },
                        
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

