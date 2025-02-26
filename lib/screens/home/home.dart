import 'package:esetu/model/usermodel.dart';
import 'package:esetu/provider/user_provider.dart';
import 'package:esetu/screens/appointments/appointments.dart';
import 'package:esetu/screens/appointments/user_appointments_list.dart';
import 'package:esetu/screens/displaySetu/display_setu.dart';
import 'package:esetu/screens/provideServices/provide_services.dart';
import 'package:esetu/screens/signin/signin.dart';
import 'package:esetu/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  addData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  void initState() {
    super.initState();
    addData();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final UserModel? user = userProvider.getUser;

    return user!.type == 'user'
        ? Scaffold(
            
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
                      padding: EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Container(
                            height: 55,
                            width: double.infinity,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '🙏 Namaste ${user.firstName}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextButton(
                                      onPressed: () async {
                                        await AuthServices().logout();
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return SigninScreen();
                                        }));
                                      },
                                      child: Text(
                                        'Logout',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          buildServiceCard('assets/images/aadhar.png',
                              'Aadhar Services', 'Aadhar card'),
                          buildServiceCard(
                              'assets/images/certificate.png',
                              'Domicile Certificate Services',
                              'Domicile certificate'),
                          buildServiceCard('assets/images/pan.png',
                              'Pan Services', 'Pan card'),
                          buildServiceCard('assets/images/card.png',
                              'Caste Certificate Services', 'Caste certificat'),
                          buildServiceCard(
                              'assets/images/certificate.png',
                              'Birth Certificate Services',
                              'Birth certificate'),
                          buildServiceCard('assets/images/card.png',
                              'Ration Card Services', 'Rashaan card'),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const ProvideServices();
                                  }));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                ),
                                child: const Text(
                                  'Provide Services',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                             
                              ElevatedButton(
                                onPressed: () {
                                   Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const UserAppointmentsList();
                                  }));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                ),
                                child: const Text(
                                  'My Appointments',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Appointments();
  }

  Widget buildServiceCard(
      String imagePath, String serviceName, String document) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DisplaySetu(
            document: document,
          );
        }));
      },
      child: Card(
        elevation: 4,
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                backgroundImage: AssetImage(imagePath),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  serviceName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
