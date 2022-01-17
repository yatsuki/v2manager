import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart' show StreamGroup;

// 启动页驻留时间
const int splashDuration = 1;


// Route 路径定义
const String rHome = '/';
const String rSplash = '/splash';
const String rV2Config = '/v2config';
const String rProxyConfig = '/proxyConfig';

class Shell {
  static Process? _shell;
  static Stream<String>? _output;

  Shell() {
    initSuperShell();
  }

  static Future<bool> initSuperShell() async {
    if (_shell != null) {
      return true;
    }
    _shell = await Process.start("su", [""], mode: ProcessStartMode.detachedWithStdio);
    _output = StreamGroup.merge([_shell!.stdout.transform(utf8.decoder), _shell!.stderr.transform(utf8.decoder)]).asBroadcastStream();
    return true;
  }

  // 执行命令并舍弃所有输出
  static Future<void> runWithNothing(String cmd) async {
    // 没有重定向语句的话增加输出重定向
    if (!cmd.endsWith(' > /dev/null 2>&1')) {
      cmd = cmd + ' > /dev/null 2>&1';
    }
    await runCmd(cmd);
    // _output.drain();
  }

  static Future<void> runCmd(String cmd) async {
    // _output.drain();
    if (_shell== null) {
      await initSuperShell();
    }
    _shell!.stdin.writeln(cmd);
    // _output.drain();
  }


  // 执行有输出语句的命令,缓慢输出的场合无法拿到所有输出信息
  static Future<String> runWithOutput(String cmd) async {
    await runCmd(cmd);
    final ret = await _output!.firstWhere((str) => str.isNotEmpty);
    _output!.drain();
    return ret;
  }
}

