import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esetu/model/usermodel.dart';
import 'package:esetu/provider/user_provider.dart';
import 'package:esetu/screens/home/home.dart';
import 'package:esetu/utils/snackbar.dart';
import 'package:esetu/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookAppointment extends StatefulWidget {
  final String setuName;
  final String setuUID;
  final String document;
  const BookAppointment(
      {super.key, required this.setuName, required this.document, required this.setuUID});

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  bool? dob = false;
  bool? name = false;
  bool? address = false;
  bool? gender = false;
  bool? caste = false;
  bool? bloodGroup = false;
  //new document
  bool isLoading = false;

  final Map<String, List<String>> documentRequirements = {
    'Update name': [
      'Aadhaar Card Copy',
      'Gazette Notification',
      'Affidavit for Name Change',
      'Passport-size Photograph'
    ],
    'Update DOB': [
      'Birth Certificate',
      'School Leaving Certificate',
      'Aadhaar Card Copy'
    ],
    'Update blood group': [
      'Medical Certificate',
      'Blood Test Report',
      'Aadhaar Card Copy'
    ],
    'Update gender': [
      'Medical Certificate',
      'Self Declaration Form',
      'Aadhaar Card Copy'
    ],
    'Update address': [
      'Utility Bill (Electricity/Water/Telephone)',
      'Rent Agreement',
      'Aadhaar Card Copy'
    ],
    'Update caste': [
      'Caste Certificate',
      'School Leaving Certificate',
      'Aadhaar Card Copy'
    ],
  };

  List<Widget> _getRequiredDocuments() {
    List<Widget> docs = [];

    if (name == true) {
      docs.add(_buildDocumentSection('Update name'));
    }
    if (dob == true) {
      docs.add(_buildDocumentSection('Update DOB'));
    }
    if (bloodGroup == true) {
      docs.add(_buildDocumentSection('Update blood group'));
    }
    if (gender == true) {
      docs.add(_buildDocumentSection('Update gender'));
    }
    if (address == true) {
      docs.add(_buildDocumentSection('Update address'));
    }
    if (caste == true) {
      docs.add(_buildDocumentSection('Update caste'));
    }

    return docs;
  }

  Widget _buildDocumentSection(String serviceName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Documents required for $serviceName:',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 5),
          ...documentRequirements[serviceName]!.map(
            (doc) => Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.black, size: 20),
                const SizedBox(width: 8),
                Text(
                  doc,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final UserModel? user = userProvider.getUser;

    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                widget.setuName,
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
                        colors: [
                          Color(0xFFFF9933),
                          Colors.white,
                          Color(0xFF138808)
                        ],
                        stops: [0.1, 0.5, 0.9],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Service',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          _buildCheckbox('Update name', name, (value) {
                            setState(() {
                              name = value;
                            });
                          }),
                          _buildCheckbox('Update DOB', dob, (value) {
                            setState(() {
                              dob = value;
                            });
                          }),
                          _buildCheckbox('Update blood group', bloodGroup,
                              (value) {
                            setState(() {
                              bloodGroup = value;
                            });
                          }),
                          _buildCheckbox('Update gender', gender, (value) {
                            setState(() {
                              gender = value;
                            });
                          }),
                          _buildCheckbox('Update address', address, (value) {
                            setState(() {
                              address = value;
                            });
                          }),
                          _buildCheckbox('Update caste', caste, (value) {
                            setState(() {
                              caste = value;
                            });
                          }),
                          const SizedBox(height: 20),
                          ..._getRequiredDocuments(),
                          GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                String updateId = DateTime.now().toString();
                                await FirebaseFirestore.instance
                                    .collection('Updates')
                                    .doc(updateId)
                                    .set({
                                  'E-Setu Name': widget.setuName,
                                  'setuUID': widget.setuUID,
                                  'name': name,
                                  'updateId': updateId,
                                  'dob': dob,
                                  'bloodGroup': bloodGroup,
                                  'gender': gender,
                                  'address': address,
                                  'caste': caste,
                                  'document': widget.document,
                                  'customerUID': user!.uid,
                                  'status':'pending'
                                });
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return HomePage();
                                }));
                                showSnackbar(
                                    'Your slot has booked with ${widget.setuName}',
                                    context);
                              },
                              child: CustomButton(
                                  buttonText: 'Book slot',
                                  buttonColor: Colors.black,
                                  textColor: Colors.white))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildCheckbox(String title, bool? value, Function(bool?) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.black,
        checkColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
}
