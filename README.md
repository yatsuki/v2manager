# V2ray Manager On Magisk

![workflow](https://github.com/yatsuki/v2manager/actions/workflows/main.yml/badge.svg)

## 关于

V2M是一个工作于Makgisk下的[V2ray-for-android]插件的管理软件,相较于之前需要在命令行中执行脚本而言,本应用提供了一个更为友好的管理界面.
也提供了一个比较简易的配置编辑界面。

## 运行环境

- [Magisk](https://github.com/topjohnwu/Magisk) v23.0+
- [V2ray-for-android](https://github.com/yatsuki/v2ray) v2.0.1+

## 已经实现的功能
- V2Ray进程的启动/停止
- iptable过滤规则启用/停止/刷新
- V2ray配置文件简易编辑(文本编辑)
- 热点共享子网代理设置
- 分应用代理选择/全局代理启用
分应用代理对象目前只能选择第三方应用(pm list packages -3)


## 原理实现
插件原始的管理方式需要在`Shell`环境下执行插件脚本来控制进程的启动/停止等。具体请参照[插件项目页面](https://github.com/yatsuki/v2ray)。
本应用也是基于插件的命令方式来实现代理的管理，应用启动时会创建一个root`Shell`环境，根据页面的操作，在底层的`Shell`环境执行相应的命令：
``` dart
_shell = await Process.start("su", [""], mode: ProcessStartMode.detachedWithStdio);
_shell.stdin.writeln('/data/adb/modules/v2ray/system/bin/v2ray --version');
```


## 预计会增加的功能
- v2ray配置文件的更加直观的编辑页面
- v2ray核心程序更新
- 分应用代理(黑名单模式、白名单模式、系统应用)

## 遇到的一些问题

在自己的开发环境(`Flutter 2.8.1`、`ArrowOS(Android 12)`、`Redme Note7(lavender)`)出现了下面的问题

- 虚拟键盘响应缓慢并伴有Exception信息[#2](https://code.lintian.co/ohnoku/v2manager/issues/2)
- 应用后台挂起之后再进入主界面出现黑屏[#1](https://code.lintian.co/ohnoku/v2manager/issues/1)

不知道是否是AOSP系统或者是Flutter版本的缘故，总之暂时在自己的环境下还未解决。


## 许可证
本应用基于[MIT](https://raw.githubusercontent.com/v2fly/v2ray-core/master/LICENSE)发布