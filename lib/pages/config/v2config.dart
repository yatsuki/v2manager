import 'package:flutter/material.dart';

import 'package:v2manager/constats.dart';

class V2ConfPage extends StatefulWidget {
  const V2ConfPage({Key? key}) : super(key: key);

  @override
  _V2ConfPageState createState() => _V2ConfPageState();
}

class _V2ConfPageState extends State<V2ConfPage> {

 
  Widget _buildContent(BuildContext context) {

    return SafeArea(child: Column(children: [],));

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("V2Ray配置"),
      ),
      body: _buildContent(context),
    );
  }
}

