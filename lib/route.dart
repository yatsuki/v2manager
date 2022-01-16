import 'package:v2manager/constats.dart';
import 'package:v2manager/pages/config/v2config.dart';
import 'package:v2manager/pages/config/proxyconfig.dart';
import 'package:v2manager/pages/home/home.dart';
import 'package:v2manager/splash.dart';

var routePath = {
  rSplash: (context) => const SplashPage(),
  rHome: (context) => const HomePage(),
  rV2Config: (context) => const V2ConfPage(),
  rProxyConfig: (context) => const ProxyConfPage(),
};
