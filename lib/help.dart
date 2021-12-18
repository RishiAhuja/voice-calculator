import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      bottomNavigationBar: ContactUsBottomAppBar(
        companyName: 'Rishi Ahuja',
        textColor: Colors.white,
        backgroundColor: Colors.indigo.shade900,
        email: 'www.rishiahuja@gmail.com',
      ),
      backgroundColor: Colors.indigo,
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/icon.png')
              ),
              SizedBox(
                height: 50,
              ),
              ContactUs(
                companyFontSize: 50,
                cardColor: Colors.white,
                textColor: Colors.indigo.shade900,
                email: 'www.rishiahuja@gmail.com',
                companyName: 'Rishi Ahuja',
                companyColor: Colors.indigo.shade100,
                phoneNumber: '+919915972220',
                githubUserName: 'RishiAhuja',
                tagLine: 'Flutter Developer',
                taglineColor: Colors.indigo.shade100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
