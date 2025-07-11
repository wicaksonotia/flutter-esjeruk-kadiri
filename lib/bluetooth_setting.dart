import 'dart:io';

import 'package:esjerukkadiri/commons/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/post_code.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:image/image.dart' as img;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal_windows.dart';

class BluetoothSetting extends StatefulWidget {
  const BluetoothSetting({super.key});

  @override
  State<BluetoothSetting> createState() => _BluetoothSettingState();
}

class _BluetoothSettingState extends State<BluetoothSetting> {
  String _info = "";
  String _msj = '';
  bool connected = false;
  List<BluetoothInfo> items = [];
  final List<String> _options = [
    "permission bluetooth granted",
    "bluetooth enabled",
    "connection status",
  ];

  String _selectSize = "2";
  final _txtText = TextEditingController(text: "Hello developer");
  bool _progress = false;
  String _msjprogress = "";

  String optionprinttype = "58 mm";
  List<String> options = ["58 mm", "80 mm"];

  @override
  void initState() {
    super.initState();
    getBluetoots();
    // autoConnectToRPP02N(); // Automatically attempt to connect to RPP02N on app start
    PrintBluetoothThermal.connectionStatus.then((bool result) {
      setState(() {
        connected = result;
        _info = "connection status: $result";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            title: const Text(
              'Bluetooth Setting',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: MyColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Get.back();
              },
            ),
            actions: [
              PopupMenuButton(
                elevation: 3.2,
                //initialValue: _options[1],
                onCanceled: () {
                  print('You have not chossed anything');
                },
                tooltip: 'Menu',
                color: Colors.white,
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (Object select) async {
                  String sel = select as String;
                  if (sel == "permission bluetooth granted") {
                    bool status =
                        await PrintBluetoothThermal
                            .isPermissionBluetoothGranted;
                    setState(() {
                      _info = "permission bluetooth granted: $status";
                    });
                    //open setting permision if not granted permision
                  } else if (sel == "bluetooth enabled") {
                    bool state = await PrintBluetoothThermal.bluetoothEnabled;
                    setState(() {
                      _info = "Bluetooth enabled: $state";
                    });
                  } else if (sel == "connection status") {
                    final bool result =
                        await PrintBluetoothThermal.connectionStatus;
                    connected = result;
                    setState(() {
                      _info = "connection status: $result";
                    });
                  }
                },
                itemBuilder: (BuildContext context) {
                  return _options.map((String option) {
                    return PopupMenuItem(value: option, child: Text(option));
                  }).toList();
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('info: $_info\n '),
                Text(_msj),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Type print"),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: optionprinttype,
                      items:
                          options.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          optionprinttype = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          getBluetoots();
                        },
                        child: Row(
                          children: [
                            Visibility(
                              visible: _progress,
                              child: const SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 1,
                                  backgroundColor: Colors.blue,
                                ),
                              ),
                            ),
                            const Gap(5),
                            Text(_progress ? _msjprogress : "Search"),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: connected ? disconnect : null,
                        child: const Text("Disconnect"),
                      ),
                      ElevatedButton(
                        onPressed: connected ? printTest : null,
                        child: const Text("Test"),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey.withAlpha(50),
                  ),
                  child: ListView.builder(
                    itemCount: items.isNotEmpty ? items.length : 0,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          String mac = items[index].macAdress;
                          connect(mac);
                        },
                        title: Text('Name: ${items[index].name}'),
                        subtitle: Text("macAddress: ${items[index].macAdress}"),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getBluetoots() async {
    setState(() {
      _progress = true;
      _msjprogress = "Wait";
      items = [];
    });
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;

    /*await Future.forEach(listResult, (BluetoothInfo bluetooth) {
      String name = bluetooth.name;
      String mac = bluetooth.macAdress;
    });*/

    setState(() {
      _progress = false;
    });

    if (listResult.length == 0) {
      _msj =
          "There are no bluetoohs linked, go to settings and link the printer";
    } else {
      _msj = "Touch an item in the list to connect";
    }

    setState(() {
      items = listResult;
    });
  }

  Future<void> connect(String mac) async {
    setState(() {
      _progress = true;
      _msjprogress = "Connecting...";
      connected = false;
    });
    final bool result = await PrintBluetoothThermal.connect(
      macPrinterAddress: mac,
    );
    print("state connected $result");
    if (result) connected = true;
    setState(() {
      _progress = false;
    });
  }

  Future<void> autoConnectToRPP02N() async {
    setState(() {
      _progress = true;
      _msjprogress = "Searching for RPP02N...";
    });

    final List<BluetoothInfo> pairedDevices =
        await PrintBluetoothThermal.pairedBluetooths;

    final BluetoothInfo? targetDevice = pairedDevices.firstWhere(
      (device) => device.name == "RPP02N",
      orElse: () => BluetoothInfo(name: '', macAdress: ''),
    );

    if (targetDevice != null) {
      await connect(targetDevice.macAdress);
    } else {
      setState(() {
        _msj = "RPP02N not found. Please pair it in Bluetooth settings.";
      });
    }

    setState(() {
      _progress = false;
    });
  }

  Future<void> disconnect() async {
    final bool status = await PrintBluetoothThermal.disconnect;
    setState(() {
      connected = false;
    });
    print("status disconnect $status");
  }

  Future<void> printTest() async {
    /*if (kDebugMode) {
      bool result = await PrintBluetoothThermalWindows.writeBytes(bytes: "Hello \n".codeUnits);
      return;
    }*/

    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    //print("connection status: $conexionStatus");
    if (conexionStatus) {
      bool result = false;
      if (Platform.isWindows) {
        List<int> ticket = await testWindows();
        result = await PrintBluetoothThermalWindows.writeBytes(bytes: ticket);
      } else {
        List<int> ticket = await testTicket();
        result = await PrintBluetoothThermal.writeBytes(ticket);
      }
      print("print test result:  $result");
    } else {
      print("print test conexionStatus: $conexionStatus");
      setState(() {
        disconnect();
      });
      //throw Exception("Not device connected");
    }
  }

  Future<void> printString() async {
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    if (conexionStatus) {
      String enter = '\n';
      await PrintBluetoothThermal.writeBytes(enter.codeUnits);
      //size of 1-5
      String text = "Hello";
      await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(size: 1, text: text),
      );
      await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(size: 2, text: "$text size 2"),
      );
      await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(size: 3, text: "$text size 3"),
      );
    } else {
      //desconectado
      print("desconectado bluetooth $conexionStatus");
    }
  }

  Future<List<int>> testTicket() async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(
      optionprinttype == "58 mm" ? PaperSize.mm58 : PaperSize.mm80,
      profile,
    );
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    final ByteData data = await rootBundle.load('assets/images/logo.png');
    final Uint8List bytesImg = data.buffer.asUint8List();
    img.Image? image = img.decodeImage(bytesImg);

    if (Platform.isIOS) {
      // Resizes the image to half its original size and reduces the quality to 80%
      final resizedImage = img.copyResize(
        image!,
        width: image.width ~/ 1.3,
        height: image.height ~/ 1.3,
        interpolation: img.Interpolation.nearest,
      );
      Uint8List.fromList(img.encodeJpg(resizedImage));
      //image = img.decodeImage(bytesimg);
    }

    //Using `ESC *`
    //bytes += generator.image(image!);

    bytes += generator.text(
      'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ',
    );
    bytes += generator.text(
      'Special 1: ñÑ àÀ èÈ éÉ üÜ çÇ ôÔ',
      styles: const PosStyles(codeTable: 'CP1252'),
    );
    bytes += generator.text(
      'Special 2: blåbærgrød',
      styles: const PosStyles(codeTable: 'CP1252'),
    );

    bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
    bytes += generator.text(
      'Reverse text',
      styles: const PosStyles(reverse: true),
    );
    bytes += generator.text(
      'Underlined text',
      styles: const PosStyles(underline: true),
      linesAfter: 1,
    );
    bytes += generator.text(
      'Align left',
      styles: const PosStyles(align: PosAlign.left),
    );
    bytes += generator.text(
      'Align center',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.text(
      'Align right',
      styles: const PosStyles(align: PosAlign.right),
      linesAfter: 1,
    );

    bytes += generator.row([
      PosColumn(
        text: 'col3',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col6',
        width: 6,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col3',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    //barcode

    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));

    //QR code
    bytes += generator.qrcode('example.com');

    bytes += generator.text(
      'Text size 50%',
      styles: const PosStyles(fontType: PosFontType.fontB),
    );
    bytes += generator.text(
      'Text size 100%',
      styles: const PosStyles(fontType: PosFontType.fontA),
    );
    bytes += generator.text(
      'Text size 200%',
      styles: const PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );

    bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> testWindows() async {
    List<int> bytes = [];

    bytes += PostCode.text(
      text: "Size compressed",
      fontSize: FontSize.compressed,
    );
    bytes += PostCode.text(text: "Size normal", fontSize: FontSize.normal);
    bytes += PostCode.text(text: "Bold", bold: true);
    bytes += PostCode.text(text: "Inverse", inverse: true);
    bytes += PostCode.text(text: "AlignPos right", align: AlignPos.right);
    bytes += PostCode.text(text: "Size big", fontSize: FontSize.big);
    bytes += PostCode.enter();

    //List of rows
    bytes += PostCode.row(
      texts: ["PRODUCT", "VALUE"],
      proportions: [60, 40],
      fontSize: FontSize.compressed,
    );
    for (int i = 0; i < 3; i++) {
      bytes += PostCode.row(
        texts: ["Item $i", "$i,00"],
        proportions: [60, 40],
        fontSize: FontSize.compressed,
      );
    }

    bytes += PostCode.line();

    bytes += PostCode.barcode(barcodeData: "123456789");
    bytes += PostCode.qr("123456789");

    bytes += PostCode.enter(nEnter: 5);

    return bytes;
  }

  Future<void> printWithoutPackage() async {
    //impresion sin paquete solo de PrintBluetoothTermal
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      String text = "${_txtText.text}\n";
      bool result = await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(size: int.parse(_selectSize), text: text),
      );
      print("status print result: $result");
      setState(() {
        _msj = "printed status: $result";
      });
    } else {
      //no conectado, reconecte
      setState(() {
        _msj = "no connected device";
      });
      print("no conectado");
    }
  }
}
