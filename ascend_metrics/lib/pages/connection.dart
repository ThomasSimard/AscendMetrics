import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

import 'package:ascend_metrics/themes/theme_constants.dart';
import 'package:ascend_metrics/themes/theme_manager.dart';

extension IntToString on int {
  String toHex() => '0x${toRadixString(16)}';
  String toPadded([int width = 3]) => toString().padLeft(width, '0');
  String toTransport() {
    switch (this) {
      case SerialPortTransport.usb:
        return 'USB';
      case SerialPortTransport.bluetooth:
        return 'Bluetooth';
      case SerialPortTransport.native:
        return 'Native';
      default:
        return 'Unknown';
    }
  }
}

ThemeManager _themeManager = ThemeManager();

class App extends StatefulWidget {
  const App({super.key});
  
  @override
  _App createState() => _App();
}

class _App extends State<App> {
  var availablePorts = [];

  @override
  void dispose(){
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(themeListener);

    initPorts();
  }

  themeListener(){
    if(mounted){
      setState(() {
        
      });
    }
  }

  void initPorts() {
    setState(() => availablePorts = SerialPort.availablePorts);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lighTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Ascend Metrics')),
          actions: [Switch(value: _themeManager.themeMode == ThemeMode.dark, onChanged: (newValue){
            _themeManager.toggleTheme(newValue);
          })],
        ),
        body: Scaffold(
          body: ListView(
            children: [
              if(availablePorts.isEmpty)
                Builder(builder: (context) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Text('Searching for a device...'),],
                  );
                }),
              for (final address in availablePorts)
                Builder(builder: (context) {
                  final port = SerialPort(address);
                  return ExpansionTile(
                    title: Text(address),
                    children: [
                      CardListTile('Description', port.description),
                      CardListTile('Transport', port.transport.toTransport()),
                      CardListTile('USB Bus', port.busNumber?.toPadded()),
                      CardListTile('USB Device', port.deviceNumber?.toPadded()),
                      CardListTile('Vendor ID', port.vendorId?.toHex()),
                      CardListTile('Product ID', port.productId?.toHex()),
                      CardListTile('Manufacturer', port.manufacturer),
                      CardListTile('Product Name', port.productName),
                      CardListTile('Serial Number', port.serialNumber),
                      CardListTile('MAC Address', port.macAddress),
                    ],
                  );
                }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: initPorts,
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}

class CardListTile extends StatelessWidget {
  final String name;
  final String? value;

  CardListTile(this.name, this.value);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(value ?? 'N/A'),
        subtitle: Text(name),
      ),
    );
  }
}