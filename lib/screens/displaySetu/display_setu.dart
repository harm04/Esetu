import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esetu/screens/book/book.dart';
import 'package:flutter/material.dart';

class DisplaySetu extends StatefulWidget {
  final String document;
  const DisplaySetu({super.key, required this.document});

  @override
  State<DisplaySetu> createState() => _DisplaySetuState();
}

class _DisplaySetuState extends State<DisplaySetu> {
  @override
  Widget build(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context);
    // final UserModel? user = userProvider.getUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.document,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFF9933), Colors.white, Color(0xFF138808)],
                  stops: [0.1, 0.5, 0.9],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Setu',
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Services')
                          .where('${widget.document}', isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Something went wrong.'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return const Center(
                              child: Text('No services found.'));
                        }

                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return BookAppointment(
                                    setuName: data['E-Setu Name'],
                                    setuUID: data['uid'],
                                    document: widget.document,
                                  );
                                }));
                              },
                              child: Card(
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 3,
                                child: ListTile(
                                  leading:
                                      const Icon(Icons.miscellaneous_services),
                                  title: Text(
                                    data['E-Setu Name'] ?? 'No Name',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                        color: Colors.black),
                                  ),
                                  subtitle: Text(
                                    data['name'] ?? 'No Name',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios_sharp),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
