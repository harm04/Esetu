import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAppointmentsList extends StatefulWidget {
  const UserAppointmentsList({super.key});

  @override
  State<UserAppointmentsList> createState() => _UserAppointmentsListState();
}

class _UserAppointmentsListState extends State<UserAppointmentsList> {
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
            .where('customerUID',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No services found.'));
          }

          // Collect all unique customer UIDs
          // List<String> customerUIDs = snapshot.data!.docs
          //     .map((doc) => doc['customerUID'].toString())
          //     .toSet()
          //     .toList();

          // // Fetch usernames for all customer UIDs
          // _fetchUsers(customerUIDs);

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index];
              // String customerUID = data['customerUID'];
              // String customerName = userNames[customerUID] ?? 'Loading...';

              return GestureDetector(
                onTap: () {
                  // Handle appointment tap
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    child: ListTile(
                      leading: const Icon(Icons.miscellaneous_services),
                      title: Text(
                        data['E-Setu Name'].toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['document'].toString(),
                            style: const TextStyle(color: Colors.grey),
                          ),
                          
                          Text(
                            data['status'].toString(),
                            style:  TextStyle(color:data['status'].toString()=='approved'?Colors.green: Colors.red),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('Updates')
                                .doc(data['updateId'].toString())
                                .delete();
                          },
                          icon: Icon(Icons.delete)),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
