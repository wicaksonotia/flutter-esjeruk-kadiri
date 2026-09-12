import 'package:cashier/commons/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothSetting extends StatefulWidget {
  const BluetoothSetting({super.key});

  @override
  State<BluetoothSetting> createState() => _BluetoothSettingState();
}

class _BluetoothSettingState extends State<BluetoothSetting> {
  static const printerMacKey = 'selected_printer_mac';
  static const printerNameKey = 'selected_printer_name';

  final List<BluetoothInfo> _printers = [];

  String? _selectedMac;
  String? _selectedName;

  bool _loading = true;
  bool _connecting = false;
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _initPrinter();
  }

  //==============================================================
  // INITIAL
  //==============================================================

  Future<void> _initPrinter() async {
    setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      final savedMac = prefs.getString(printerMacKey);
      final savedName = prefs.getString(printerNameKey);

      final paired = await PrintBluetoothThermal.pairedBluetooths;

      _printers
        ..clear()
        ..addAll(paired);

      _selectedMac = savedMac;
      _selectedName = savedName;

      // Status koneksi saat ini
      _connected = await PrintBluetoothThermal.connectionStatus;

      // Auto connect printer yang pernah dipilih
      if (savedMac != null && paired.isNotEmpty) {
        final printer = paired.cast<BluetoothInfo?>().firstWhere(
          (e) => e!.macAdress == savedMac,
          orElse: () => null,
        );

        if (printer != null) {
          await _connectPrinter(printer, silent: true);
        }
      }
      // Kalau cuma satu printer → otomatis pilih
      else if (paired.length == 1) {
        await _selectPrinter(paired.first, silent: true);
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  //==============================================================
  // REFRESH
  //==============================================================

  Future<void> _refreshPrinters() async {
    final paired = await PrintBluetoothThermal.pairedBluetooths;

    setState(() {
      _printers
        ..clear()
        ..addAll(paired);
    });
  }

  //==============================================================
  // SELECT PRINTER
  //==============================================================

  Future<void> _selectPrinter(
    BluetoothInfo printer, {
    bool silent = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(printerMacKey, printer.macAdress);

    await prefs.setString(printerNameKey, printer.name);

    setState(() {
      _selectedMac = printer.macAdress;
      _selectedName = printer.name;
    });

    await _connectPrinter(printer, silent: silent);
  }

  //==============================================================
  // CONNECT
  //==============================================================

  Future<void> _connectPrinter(
    BluetoothInfo printer, {
    bool silent = false,
  }) async {
    setState(() => _connecting = true);

    try {
      final status = await PrintBluetoothThermal.connectionStatus;

      if (!status) {
        await PrintBluetoothThermal.connect(
          macPrinterAddress: printer.macAdress,
        );
      }

      _connected = await PrintBluetoothThermal.connectionStatus;

      if (!silent && _connected) {
        Get.snackbar(
          'Printer',
          '${printer.name} berhasil terhubung',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      _connected = false;

      if (!silent) {
        _showError('Gagal menghubungkan printer');
      }
    }

    if (mounted) {
      setState(() => _connecting = false);
    }
  }

  //==============================================================
  // DISCONNECT
  //==============================================================

  Future<void> _disconnect() async {
    await PrintBluetoothThermal.disconnect;

    setState(() => _connected = false);
  }

  //==============================================================
  // CLEAR
  //==============================================================

  Future<void> _clearPrinter() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(printerMacKey);
    await prefs.remove(printerNameKey);

    await _disconnect();

    setState(() {
      _selectedMac = null;
      _selectedName = null;
    });
  }

  //==============================================================
  // TEST PRINT
  //==============================================================

  Future<void> _testPrint() async {
    if (_selectedMac == null) {
      _showError('Pilih printer terlebih dahulu');
      return;
    }

    final status = await PrintBluetoothThermal.connectionStatus;

    if (!status) {
      final printer = _printers.cast<BluetoothInfo?>().firstWhere(
        (e) => e!.macAdress == _selectedMac,
        orElse: () => null,
      );

      if (printer == null) {
        _showError('Printer tidak ditemukan');
        return;
      }

      await _connectPrinter(printer);
    }

    final connected = await PrintBluetoothThermal.connectionStatus;

    if (!connected) return;

    await PrintBluetoothThermal.writeString(
      printText: PrintTextSize(
        size: 1,
        text:
            '\n'
            '=============================\n'
            '        TEST PRINT\n'
            '=============================\n'
            'Printer : ${_selectedName ?? '-'}\n'
            'MAC     : ${_selectedMac ?? '-'}\n'
            'Status  : Connected\n'
            '=============================\n'
            '\n\n\n',
      ),
    );

    Get.snackbar(
      'Berhasil',
      'Test print berhasil',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void _showError(String msg) {
    Get.snackbar(
      'Printer',
      msg,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  //==============================================================
  // UI
  //==============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Bluetooth Printer'),
        actions: [
          IconButton(
            onPressed: _refreshPrinters,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _refreshPrinters,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _activePrinterCard(),
                    const SizedBox(height: 16),
                    _printerListCard(),
                    if (_selectedMac != null) ...[
                      const SizedBox(height: 20),
                      _actionButtons(),
                    ],
                  ],
                ),
              ),
    );
  }

  //==============================================================
  // ACTIVE CARD
  //==============================================================

  Widget _activePrinterCard() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor:
                  _connected ? Colors.green.shade50 : Colors.grey.shade200,
              child: Icon(
                Icons.print,
                color: _connected ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Printer Aktif',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedName ?? 'Belum dipilih',
                    style: const TextStyle(fontSize: 15),
                  ),
                  if (_selectedMac != null)
                    Text(
                      _selectedMac!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
            ),
            if (_connecting)
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(
                _connected ? Icons.check_circle : Icons.cancel,
                color: _connected ? Colors.green : Colors.grey,
              ),
          ],
        ),
      ),
    );
  }

  //==============================================================
  // LIST
  //==============================================================

  Widget _printerListCard() {
    return Card(
      elevation: 0,
      child: Column(
        children: [
          const ListTile(
            title: Text(
              'Perangkat Bluetooth',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          if (_printers.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('Belum ada printer yang dipairing')),
            )
          else
            ..._printers.map(_printerTile),
        ],
      ),
    );
  }

  Widget _printerTile(BluetoothInfo printer) {
    final selected = printer.macAdress == _selectedMac;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: _connecting ? null : () => _selectPrinter(printer),
        leading: CircleAvatar(
          backgroundColor:
              selected
                  ? MyColors.primary.withValues(alpha: .1)
                  : Colors.grey.shade200,
          child: Icon(
            Icons.print,
            color: selected ? MyColors.primary : Colors.grey.shade700,
          ),
        ),
        title: Text(
          printer.name.isEmpty ? 'Unknown Printer' : printer.name,
          style: TextStyle(
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(printer.macAdress),
        trailing:
            selected
                ? Icon(
                  _connected ? Icons.check_circle : Icons.radio_button_checked,
                  color: _connected ? Colors.green : MyColors.primary,
                )
                : const Icon(Icons.chevron_right),
      ),
    );
  }

  //==============================================================
  // ACTIONS
  //==============================================================

  Widget _actionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _connecting ? null : _testPrint,
            icon: const Icon(Icons.print),
            label: const Text('Test Print'),
          ),
        ),
        const SizedBox(height: 10),
        if (_connected)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _disconnect,
              icon: const Icon(Icons.bluetooth_disabled),
              label: const Text('Disconnect'),
            ),
          ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _clearPrinter,
          child: const Text(
            'Hapus Printer Terpilih',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
