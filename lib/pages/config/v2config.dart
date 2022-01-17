import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:v2manager/constats.dart' show Shell;

class V2ConfPage extends StatefulWidget {
  const V2ConfPage({Key? key}) : super(key: key);

  @override
  _V2ConfPageState createState() => _V2ConfPageState();
}

class _V2ConfPageState extends State<V2ConfPage> {

  final PageController _ctl = PageController();
  final TextEditingController _strCtl = TextEditingController();
  String _cur = "文本编辑";
  
  String _configStr = "";
  Map<String, dynamic> _configMap = {};
 
  void _saveToFile() async {
    if (kDebugMode) {
      // print(_configStr);
      // final str = _configStr.replaceAll('\n', '\\n');
      // print("echo '$str' > /data/v2ray/config.json");
    }
    await Shell.runCmd("echo '$_configStr' > /data/v2ray/config.json");
  }

  void _readFromFile() async {
    _configStr = await Shell.runWithOutput("cat /data/v2ray/config.json");
    _configMap = json.decode(_configStr);
    if (kDebugMode) {
      print(_configMap);
    }
    _strCtl.text = _configStr;
    setState(() { });
  }

  void _updateEditingStr(String str) {
    _configStr = str;
  }

  void _undoChange(){
    _readFromFile();
  }

  void _updatePageBtn(int page) {
    if (page == 0) {
      _cur = '文本编辑';
    } else {
      _cur = '对象编辑';
    }
    setState(() {});
  }

  void _toggleSwitch(){
    if (kDebugMode) {
      print(_ctl.page);
    }
    if (_ctl.page==0.0) {
      _cur = '对象编辑';
      _ctl.jumpToPage(1);
    } else {
      _cur = '文本编辑';
      _ctl.jumpToPage(0);
    }
    setState(() {});
  }

  @override
  void initState(){
    super.initState();
    _readFromFile();
  }

  Widget _buildObjectEditor(){
    return const Center(child: Text("页面施工中", style: TextStyle(fontSize: 20)));
  }

  Widget _buildTextEditor(){
    return SingleChildScrollView(child: TextField(keyboardType: TextInputType.text, maxLines: null, controller: _strCtl, onChanged: _updateEditingStr));
  }

  Widget _buildContent(BuildContext context) {

    return SafeArea(child:
      PageView(onPageChanged: _updatePageBtn, controller: _ctl,children: [_buildObjectEditor(), _buildTextEditor()])
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("V2Ray配置"),
        actions: [
          TextButton(onPressed: _toggleSwitch, child: Text(_cur, style: TextStyle(color:Theme.of(context).cardColor))),
          IconButton(onPressed: _saveToFile, icon: const Icon(Icons.save))
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _undoChange, child: const Icon(Icons.refresh_outlined)),
      body: _buildContent(context),
    );
  }
}

