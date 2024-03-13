import 'package:admin/components/setTime.dart';
import 'package:admin/components/PriceUpdate.dart';
import 'package:admin/pages/Manage.dart';
import 'package:flutter/material.dart';
import 'package:admin/components/contact_update.dart';
import 'package:admin/pages/Manage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              setTime(),
              PriceUpdate(),
              ContactUpdate(),
              Manage(),
            ],
          ),
        )
    );
  }
}
