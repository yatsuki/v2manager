import 'package:flutter/material.dart';
import 'package:v2manager/constats.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _platform = "";
  int _pid = 0;
  String _version = "";
  bool _actived = false;

  String _modVersion = "";
  final String _modLatest = "20220119";
  bool _iptablesActived = false;

  Future _initBasicInfo() async {

    // Check Program exist
    final chkRet = await Shell.runWithOutput('md5sum /data/adb/modules/v2ray/system/bin/v2ray');
    final modMD5 = chkRet.substring(0, chkRet.indexOf(' '));
 
    final verRet = await Shell.runWithOutput('/data/adb/modules/v2ray/system/bin/v2ray --version');
    _version = verRet.substring(6, verRet.indexOf('('));
    _platform = verRet.substring(verRet.lastIndexOf('(') + 1, verRet.lastIndexOf(')'));


    final enabledRet = await Shell.runWithOutput('md5sum /system/bin/v2ray');
    final sysBinMD5 = enabledRet.substring(0, chkRet.indexOf(' '));
    _actived = sysBinMD5.compareTo(modMD5) == 0;


    final pidRet = await Shell.runWithOutput('/data/adb/modules/v2ray/scripts/v2ray.service status');
    if (pidRet.indexOf('PID: ') > 0) { 
      _pid = int.parse(pidRet.substring(pidRet.indexOf('PID: ')+5, pidRet.lastIndexOf(' ')));
    }

    // versionCode=20210801
    final modVerRet = await Shell.runWithOutput('grep versionCode /data/adb/modules/v2ray/module.prop');
    _modVersion = modVerRet.substring(modVerRet.indexOf('=')+1, modVerRet.length).trim();

    // 查看时排除错误输出
    final ipRet = await Shell.runWithOutput('iptables -t nat -L V2RAY 2>/dev/null | wc -l');
    _iptablesActived = int.parse(ipRet) > 0;
  
    setState(() {});
  }

  Future _toggleV2rayRun() async {
    String script = "/data/adb/modules/v2ray/scripts/v2ray.service";
    // 执行时丢弃所有输出
    await Shell.runWithNothing(script + (_pid > 0? ' stop' : ' start'));

    final pidRet = await Shell.runWithOutput(script + " status");

    setState(() {
      if (pidRet.indexOf('PID: ') > 0) {
        _pid = int.parse(pidRet.substring(pidRet.indexOf('PID: ') + 5, pidRet.lastIndexOf(' ')));
      } else {
        _pid = 0;
      }
    });
  }

  // void _toggleV2rayUpdate() {

  // }

  Future _toggleIptablesRules() async {
    String script = "/data/adb/modules/v2ray/scripts/v2ray.tproxy";
    await Shell.runWithNothing(script + (_iptablesActived ? ' disable' : ' enable'));

    final ipRet = await Shell.runWithOutput("iptables -t nat -L V2RAY 2>/dev/null | wc -l");
    var count = int.parse(ipRet);

    setState(() { 
      _iptablesActived = count > 0;
    });

  }

  Future _toggleIptablesFlash() async {
    // 丢弃所有输出，不做任何处理
    Shell.runWithNothing("/data/adb/modules/v2ray/scripts/v2ray.tproxy renew");

    setState(() { _iptablesActived = true; });
  }


  @override
  void initState(){
    super.initState();
    _initBasicInfo();
  }

  Widget _buildV2rayCard() {
    return Card(
      elevation: 5.0,
      color: Theme.of(context).secondaryHeaderColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(top: 16),
      child: Container(margin: const EdgeInsets.only(top:16, left:32, right:32, bottom: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // 第一行 V2ray+按钮
        Row(children: [
          ImageIcon(const AssetImage("assets/v2ray.png"), size: 32, color: Theme.of(context).primaryColor,),
          const SizedBox(width: 8),
          Text("主程序", style: TextStyle(fontSize: 28,fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor )), 
          const Spacer(),
          // IconButton(onPressed: () => {}, icon: Icon(Icons.arrow_circle_up_outlined, color: Theme.of(context).primaryColor), tooltip: "更新V2Ray主程序"),
          IconButton(onPressed: _toggleV2rayRun, icon: Icon(_pid == 0 ? Icons.play_circle_outlined: Icons.pause_circle_outlined, color: Theme.of(context).primaryColor), tooltip: "启动/停止V2Ray进程"),
        ]),
        Container(margin: EdgeInsets.zero, child: Column(children:[
        // 第二行 版本
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Text("平台:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color:Colors.grey)),
          const SizedBox(width:4),
          Text(_platform, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ]),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Text("版本:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color:Colors.grey)),
          const SizedBox(width:4),
          Text(_version, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ]),
        Row(crossAxisAlignment: CrossAxisAlignment.end,children: [
          const Text("启用:"  , style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color:Colors.grey)),
          const SizedBox(width:4),
          Text( _actived ? "是" : "否" ,style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width:48),
          const Text("PID:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color:Colors.grey)),
          const SizedBox(width:4),
          Text(_pid.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ]),])),
      ])
    ));
  }

  Widget _buildModuleCard(){

    return Card(
      elevation: 5.0,
      color: Theme.of(context).secondaryHeaderColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(top: 16),
      child: Container(margin: const EdgeInsets.only(top:16, left:32, right:32, bottom: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // 第一行 标题
        Row(children: [
          ImageIcon(const AssetImage("assets/magisk.png"), color: Theme.of(context).primaryColor, size: 32,),
          const SizedBox(width: 8),
          Text("模块", style: TextStyle(fontSize: 28,fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor)), 
          const Spacer(),
          IconButton(onPressed: _toggleIptablesFlash, icon: Icon(Icons.bolt_outlined, color: Theme.of(context).primaryColor), tooltip: "刷新Iptables规则"),
          IconButton(onPressed: _toggleIptablesRules, icon: Icon(_iptablesActived ? Icons.stop_circle_outlined : Icons.play_circle_outlined, color: Theme.of(context).primaryColor), tooltip: "启动/停止Iptables拦截"),
        ]),
        Container(margin: EdgeInsets.zero, child: Column(children:[
          // 第二行 版本
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Text("最新:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color:Colors.grey)),
            const SizedBox(width: 4),
            Text(_modLatest, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ]),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Text("当前:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color:Colors.grey)),
            const SizedBox(width: 4),
            Text(_modVersion, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ]),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Text("Iptables过滤:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey)),
            const SizedBox(width: 4),
            Text(_iptablesActived ? "过滤中": "未启用", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ]),
        ])),

      ])
    ));
  }

  Widget _buildConfigLine(){
    return Container(margin: const EdgeInsets.only(top:16, bottom: 16), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      InkWell(onTap:()=>Navigator.pushNamed(context, rV2Config), child:Container(padding: const EdgeInsets.all(4) ,width:150, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(8))), child:Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Icon(Icons.settings, size: 48, color: Theme.of(context).primaryColor),
        Text("代理规则", style: TextStyle(color: Theme.of(context).primaryColor)),
      ]))),
      const SizedBox(width:16),
      InkWell(onTap:()=>Navigator.pushNamed(context, rProxyConfig), child:Container(padding: const EdgeInsets.all(4) ,width:150, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(8))), child:Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Icon(Icons.tune, size: 48, color: Theme.of(context).primaryColor),
        Text("代理对象", style: TextStyle(color: Theme.of(context).primaryColor)),
      ]))),
    ]));
  }

  Widget _buildSupportCard(){
    return Card(
      elevation: 5.0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.zero,
      child: Container(margin: const EdgeInsets.only(top:16, left:16, right:24, bottom: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        const Text("关于", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text("此应用是基于Magisk的V2ray插件管理应用，使用前请确保已安装Magisk以及V2ray for Android插件且在使用时赋予root权限。", softWrap: true, style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 16),
        const Text("支持", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text("本应用将一直保持免费开源，感谢大家一如既往的支持", softWrap: true, style: TextStyle(fontSize: 8, color: Colors.grey)),
        Row(children: [
          IconButton(onPressed: (){}, icon: Image.asset("assets/github.png",), color: Colors.black87, iconSize: 32,),
          IconButton(onPressed: (){}, icon: Image.asset("assets/blog.png",), color: Colors.black87, iconSize: 32,),
        ]),

      ])));
  }

  Widget _buildContent(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(children: [
        // Main info
        _buildV2rayCard(), 
        _buildModuleCard(),
        _buildConfigLine(),
        // const Spacer(),
        _buildSupportCard()
        // Settings
      ]
    ));

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // title: Text("主页", style: Theme.of(context).textTheme.headline6),

      ),
      body: _buildContent(context),

    );
  }
}
