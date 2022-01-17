import 'package:flutter/material.dart';

import 'package:v2manager/constats.dart';

class ProxyConfPage extends StatefulWidget {
  const ProxyConfPage({Key? key}) : super(key: key);

  @override
  _ProxyConfPageState createState() => _ProxyConfPageState();
}

class _ProxyConfPageState extends State<ProxyConfPage> {

  String _subnet = ""; 
  bool? _isAll = false;
  List<String> _apps = [];
  final List<String> _appids = [];
  final List<bool> _appsEnable = [];

  @override
  void initState(){
    super.initState();
    _getApps();
  }

  void _getApps() async {
    final strs = await Shell.runWithOutput("pm list packages -3");
    final enabledApp = await Shell.runWithOutput('cat /data/v2ray/appid.list');
    _apps = strs.replaceAll('package:', '').trimRight().split('\n');
    for (final namespace in _apps) {
      final s = await Shell.runWithOutput("grep '$namespace' /data/system/packages.list");
      final i = s.indexOf(' ');
      final j = s.indexOf(' ', i+1);
      final appid = s.substring(i+1, j);
      _appids.add(appid);
      _appsEnable.add(enabledApp.contains(appid));
    }
    setState(() {});
  }

  void _toogleAllProxy(bool? val) async {
    if (val!) {
      await Shell.runCmd("echo '0' > /data/v2ray/appid.list");
      for(var i = 0;i< _appsEnable.length;i++){
        _appsEnable[i] = false;
      }
    } else {
      await Shell.runCmd("rm /data/v2ray/appid.list");
    }
    _isAll = val;
    setState(() {});
  }

  void _toogleAppProxy(bool val, int idx) async {
    if (_isAll!) {
      return;
    }
    final appid = _appids[idx];
    if (val) {
      await Shell.runCmd("echo $appid >> /data/v2ray/appid.list");
    } else {
      await Shell.runCmd("sed '/$appid/d' /data/v2ray/appid.list > /data/v2ray/appid.tmp && cat /data/v2ray/appid.tmp > /data/v2ray/appid.list && rm /data/v2ray/appid.tmp");
    }
    setState(() {_appsEnable[idx] = val;});
  }

  void _saveShareSubnet() async {
    await Shell.runCmd("echo '$_subnet' > /data/v2ray/softap.list");
  }

  void _showShareSubnet() {
    showDialog(context: context, builder: _buildSubnetModal);
  }

  Widget _buildAppListItem(BuildContext context, int idx){
    return SwitchListTile(value: _appsEnable[idx], onChanged: (bool val){_toogleAppProxy(val, idx);}, title: Text(_apps[idx]));
  }

  Widget _buildSubnetModal(BuildContext context){
    return AlertDialog(title: const Text('代理共享热点子网'), content: TextField(onChanged:(String val){_subnet = val;}), actions: [
      TextButton(onPressed: (){Navigator.of(context).pop();}, child: const Text('取消')),
      TextButton(onPressed: _saveShareSubnet, child: const Text('保存'))
    ],);
  }

  Widget _buildContent(BuildContext context) {
    return SafeArea(child: Column(children: [
      CheckboxListTile(value: _isAll, onChanged: _toogleAllProxy, title: const Text("全局代理")),
      Expanded(child: ListView.builder(itemCount: _apps.length, shrinkWrap:true, itemBuilder:_buildAppListItem)),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("代理对象"),
        actions: [
          IconButton(onPressed: _showShareSubnet, icon: const Icon(Icons.wifi_tethering_outlined))
        ],
      ),
      body: _buildContent(context),
    );
  }
}

