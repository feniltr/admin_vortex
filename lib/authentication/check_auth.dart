import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:admin/main.dart';
import 'package:admin/pages/mainpage.dart';
import 'auth_page.dart';


class CheckAuth extends StatelessWidget {
  const CheckAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return MainPage(); //place here MainPage
          }
          else {
            return Auth_page();
          }
        });
  }
}
