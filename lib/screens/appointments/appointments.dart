// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class Appointments extends StatefulWidget {
//   const Appointments({super.key});

//   @override
//   State<Appointments> createState() => _AppointmentsState();
// }

// class _AppointmentsState extends State<Appointments> {
//   // String? esetuname;
//   // Map<String, String> userNames = {}; // Map to store customer UID and names

//   @override
//   void initState() {
//     super.initState();
//     // _fetchEsetuName();
//   }

//   // // Fetch the E-Setu Name from the 'Services' collection
//   // Future<void> _fetchEsetuName() async {
//   //   final userProvider = Provider.of<UserProvider>(context, listen: false);
//   //   final UserModel? user = userProvider.getUser;

//   //   if (user != null) {
//   //     DocumentSnapshot snapshot = await FirebaseFirestore.instance
//   //         .collection('Services')
//   //         .doc(user.uid)
//   //         .get();

//   //     if (snapshot.exists) {
//   //       setState(() {
//   //         esetuname = snapshot['E-Setu Name'];
//   //       });
//   //       print('E-Setu Name: $esetuname');
//   //     }
//   //   }
//   // }

// // Fetch usernames in bulk for a list of customer UIDs
// Future<void> _fetchUsers(List<String> uids) async {
//   for (String uid in uids) {
//     if (!userNames.containsKey(uid)) {
//       DocumentSnapshot snapshot =
//           await FirebaseFirestore.instance.collection('Users').doc(uid).get();

//       if (snapshot.exists) {
//         setState(() {
//           userNames[uid] = '${snapshot['firstName']} ${snapshot['lastName']}';
//         });
//       } else {
//         setState(() {
//           userNames[uid] = 'Unknown User';
//         });
//       }
//     }
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Appointments'),
//         // actions: [
//         //   IconButton(
//         //     onPressed: () {
//         //       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         //         return ProvideServices();
//         //       }));
//         //     },
//         //     icon: const Icon(Icons.add),
//         //   )
//         // ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('Updates')
//             .where('setuUID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text('Something went wrong.'));
//           } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No services found.'));
//           }

//           // Collect all unique customer UIDs
//           // List<String> customerUIDs = snapshot.data!.docs
//           //     .map((doc) => doc['customerUID'].toString())
//           //     .toSet()
//           //     .toList();

//           // Fetch usernames for all customer UIDs
//           // _fetchUsers(customerUIDs);

//           return Expanded(
//             child: ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 var data = snapshot.data!.docs[index];
//                 // String customerUID = data['customerUID'];
//                 // String customerName = userNames[customerUID] ?? 'Loading...';

//                 return GestureDetector(
//                   onTap: () {
//                     // Handle appointment tap
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(18.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Card(
//                           color: Colors.white,
//                           margin: const EdgeInsets.symmetric(vertical: 8),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           elevation: 3,
//                           child: ListTile(
//                             leading: const Icon(Icons.miscellaneous_services),
//                             title: Text(
//                              ' customerName',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             subtitle: Text(
//                               data['customerUID'].toString(),
//                               style: const TextStyle(color: Colors.grey),
//                             ),
//                           ),
//                         ),
// GestureDetector(
//   onTap: () {
//     FirebaseFirestore.instance
//         .collection('Updates')
//         .doc(data['updateId'])
//         .update({'status': 'approved'});
//   },
//   child: Container(
//     height: 40,
//     width: 40,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(60),
//       color: Colors.green,
//     ),
//     child: Center(
//       child: Icon(Icons.check),
//     ),
//   ),
// ),
// GestureDetector(
//   onTap: () {
//     FirebaseFirestore.instance
//         .collection('Updates')
//         .doc(data['updateId'])
//         .update({'status': 'rejected'});
//   },
//   child: Container(
//     height: 40,
//     width: 40,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(60),
//       color: Colors.red,
//     ),
//     child: Center(
//       child: Icon(Icons.close),
//     ),
//   ),
// ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esetu/screens/appointments/admin_appointments_list.dart';
import 'package:esetu/screens/signin/signin.dart';
import 'package:esetu/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  // Function to fetch customer name from Firestore
  Future<String> _getCustomerName(String customerUID) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(customerUID)
          .get();

      if (userSnapshot.exists) {
        var userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null &&
            userData.containsKey('firstName') &&
            userData.containsKey('lastName')) {
          return '${userData['firstName']} ${userData['lastName']}';
        }
      }
      return 'Unknown Customer';
    } catch (e) {
      return 'Unknown Customer';
    }
  }

  // Function to update appointment status
  void _updateStatus(String appointmentId, String status) {
    FirebaseFirestore.instance.collection('Updates').doc(appointmentId).update({
      'status': status,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment $status')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status.')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AdminAppointmentsList();
                    }));
                  },
                  child: Text(
                    'My Appointments',
                    style: TextStyle(color: Colors.white),
                  )),
              ElevatedButton(
                onPressed: () async {
                  await AuthServices().logout();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return SigninScreen();
                  }));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Updates')
            .where('setuUID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .where('status', isEqualTo: 'pending')
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

                if (data == null ||
                    !data.containsKey('customerUID') ||
                    !data.containsKey('updateId')) {
                  return const SizedBox.shrink(); // Skip if data is invalid
                }

                String customerUID = data['customerUID'];
                String appointmentId =
                    data['updateId']; // Unique ID of appointment

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
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        subtitle: Text(
                          data['document'],
                          style: const TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          // Handle appointment tap
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Approve Button
                            IconButton(
                              icon:
                                  const Icon(Icons.check, color: Colors.green),
                              onPressed: () =>
                                  _updateStatus(appointmentId, 'approved'),
                            ),
                            // Reject Button
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () =>
                                  _updateStatus(appointmentId, 'rejected'),
                            ),
                          ],
                        ),
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
