import 'package:flutter/material.dart';

import '../../../themes/constants.dart';

class ProfilePageE extends StatefulWidget {
  const ProfilePageE({super.key});

  @override
  State<ProfilePageE> createState() => _ProfilePageEState();
}

class _ProfilePageEState extends State<ProfilePageE> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldbackground,
      body: SingleChildScrollView(
        child: Column(children: [
          Center(
            child: Text('sdfdsf'),
          ),
        ]),
      ),
    );
  }
}
