import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esetu/model/usermodel.dart';
import 'package:esetu/provider/user_provider.dart';
import 'package:esetu/widgets/custom_button.dart';
import 'package:esetu/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProvideServices extends StatefulWidget {
  const ProvideServices({super.key});

  @override
  State<ProvideServices> createState() => _ProvideServicesState();
}

class _ProvideServicesState extends State<ProvideServices> {
  final TextEditingController setunamecontroller = TextEditingController();
  bool? aadhar = false;
  bool? pan = false;
  bool? domicile = false;
  bool? birth = false;
  bool? caste = false;
  bool? rashan = false;
  // bool? detailsChecked = false;
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();
    setunamecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Provide services',
          style: TextStyle(color: Colors.white, fontSize: 23),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextfield(
                  hintText: 'E-Setu Name',
                  type: TextInputType.text,
                  controller: setunamecontroller,
                  obsecureText: false),
              SizedBox(
                height: 20,
              ),
              Text(
                'Select Services',
                style: TextStyle(color: Colors.black, fontSize: 23),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CheckboxListTile(
                  value: aadhar,
                  onChanged: (bool? newValue) {
                    setState(() {
                      aadhar = newValue;
                    });
                  },
                  activeColor: Colors.black,
                  checkColor: Colors.white,
                  title: const Text(
                    'Aadhar card',style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CheckboxListTile(
                  value: pan,
                  onChanged: (bool? newValue) {
                    setState(() {
                      pan = newValue;
                    });
                  },
                  activeColor: Colors.black,
                  checkColor: Colors.white,
                  title: const Text('Pan card',style: TextStyle(color: Colors.black),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CheckboxListTile(
                  value: domicile,
                  onChanged: (bool? newValue) {
                    setState(() {
                      domicile = newValue;
                    });
                  },
                  activeColor: Colors.black,
                  checkColor: Colors.white,
                  title: const Text('Domicile certificate',style: TextStyle(color: Colors.black),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CheckboxListTile(
                  value: caste,
                  onChanged: (bool? newValue) {
                    setState(() {
                      caste = newValue;
                    });
                  },
                  activeColor: Colors.black,
                  checkColor: Colors.white,
                  title: const Text('Caste certificate',style: TextStyle(color: Colors.black),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CheckboxListTile(
                  value: birth,
                  onChanged: (bool? newValue) {
                    setState(() {
                      birth = newValue;
                    });
                  },
                  activeColor: Colors.black,
                  checkColor: Colors.white,
                  title: const Text('Birth certificate',style: TextStyle(color: Colors.black),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CheckboxListTile(
                  value: rashan,
                  onChanged: (bool? newValue) {
                    setState(() {
                      rashan = newValue;
                    });
                  },
                  activeColor: Colors.black,
                  checkColor: Colors.white,
                  title: const Text('Rashaan card',style: TextStyle(color: Colors.black),),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (aadhar == true ||
                      pan == true ||
                      domicile == true ||
                      caste == true ||
                      birth == true ||
                      rashan == true) {
                    await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(user.uid)
                        .update({
                      'type': 'provider',
                    });
                    // ignore: use_build_context_synchronously
                    Provider.of<UserProvider>(context, listen: false)
                        .updateUser(
                      type: 'provider',
                    );
                    await FirebaseFirestore.instance
                        .collection('Services')
                        .doc(user.uid)
                        .set({
                      'E-Setu Name': setunamecontroller.text,
                      'Aadhar card': aadhar,
                      'Pan card': pan,
                      'Domicile certificate': domicile,
                      'Caste certificate': caste,
                      'Birth certificate': birth,
                      'Rashaan card': rashan,
                      'name': '${user.firstName} ${user.lastName}',
                      'email': user.email,
                      'uid': user.uid
                    });
                    setState(() {
                      isLoading = false;
                    });
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
                },
                child: CustomButton(
                    buttonText: 'Sumbit',
                    buttonColor: Colors.black,
                    textColor: Colors.white),
              )
            ],
          ),
        ),
      )),
    );
  }
}
