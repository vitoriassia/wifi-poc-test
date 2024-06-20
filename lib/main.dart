import 'package:flutter/material.dart';
import 'package:plugin_wifi_connect/plugin_wifi_connect.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:wifiot/webview_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isConnect = false;

  void _connect(WiFiAccessPoint accessPoint) async {
    var result = await PluginWifiConnect.connect(accessPoint.ssid, saveNetwork: true);

    setState(() {
      _isConnect = result ?? false;
    });

    if (_isConnect) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const WebViewExample(),
        ),
      );
    }
  }

  void _startScan() async {
    _isConnect = false;
    // check platform support and necessary requirements
    final can = await WiFiScan.instance.canStartScan(askPermissions: true);

    if (can == CanStartScan.yes) {
      // start full scan async-ly
      await WiFiScan.instance.startScan();

      final result = await WiFiScan.instance.getScannedResults();

      _connect(result[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_isConnect',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startScan,
        tooltip: 'Connect',
        child: const Icon(Icons.wifi),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
