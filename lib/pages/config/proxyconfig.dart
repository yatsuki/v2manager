import 'package:flutter/material.dart';

import 'package:v2manager/constats.dart';

class ProxyConfPage extends StatefulWidget {
  const ProxyConfPage({Key? key}) : super(key: key);

  @override
  _ProxyConfPageState createState() => _ProxyConfPageState();
}

class _ProxyConfPageState extends State<ProxyConfPage> {

 
  Widget _buildContent(BuildContext context) {

    return SafeArea(child: Column(children: [],));

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("代理配置"),
      ),
      body: _buildContent(context),
    );
  }
}

